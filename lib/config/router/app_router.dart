import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';


final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      //* First Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      //* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      //* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductScreen(
          productId: state.params['id'] ?? 'no-id',
        ),
      ),
    ],
    
    redirect: (context, state) {
      final destination = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if (destination == '/splash' && authStatus == AuthStatus.checking) return null;

      if (authStatus == AuthStatus.unauthenticated) {
        if (destination == '/login' || destination == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (destination == '/login' || destination == '/register' || destination == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});