import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/products.dart';
import 'package:teslo_shop/features/shared/shared.dart';


final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  // final createUpdateCallback = ref.watch(productsRepositoryProvider).createUpdateProduct;
  final createUpdateCallback = ref.watch(productsProvider.notifier).createOrUpdateProduct;

  return ProductFormNotifier(
    product: product,
    onSubmitCallback: createUpdateCallback
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product
  }): super(ProductFormState(
    id: product.id,
    title: Title.dirty(product.title),
    slug: Slug.dirty(product.slug),
    price: Price.dirty(product.price),
    stock: Stock.dirty(product.stock),
    sizes: product.sizes,
    gender: product.gender,
    description: product.description,
    tags: product.tags.join(', '),
    images: product.images,
  ));

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value)
      ])
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value)
      ])
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(value),
        Stock.dirty(state.stock.value)
      ])
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      stock: Stock.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(value)
      ])
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(
      sizes: sizes
    );
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender
    );
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags
    );
  }

  void onImagesChanged(String path) {
    state = state.copyWith(
      images: [...state.images, path]
    );
  }

  Future<bool> onFormSubmit() async {
    _touchFields();

    if(!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
      'title': state.title.value,
      'slug': state.slug.value,
      'price': state.price.value,
      'stock': state.stock.value,
      'description': state.description,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images.map(
        (image) => image.replaceAll('${Environment.apiUrl}/files/product/', '')
      ).toList()
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchFields() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.stock.value)
      ])
    );
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock stock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false, 
    this.id, 
    this.title = const Title.pure(), 
    this.slug = const Slug.pure(), 
    this.price = const Price.pure(), 
    this.sizes = const [], 
    this.gender = '', 
    this.stock = const Stock.pure(), 
    this.description = '', 
    this.tags = '', 
    this.images = const []
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? stock,
    String? description,
    String? tags,
    List<String>? images
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    stock: stock ?? this.stock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images
  );
}