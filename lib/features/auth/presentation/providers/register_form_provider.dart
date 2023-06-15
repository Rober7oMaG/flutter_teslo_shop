import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
}); 

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback
  }) : super(RegisterFormState());

  void onNameChanged(String value) {
    final newName = Name.dirty(value);

    state = state.copyWith(
      fullName: newName,
      isValid: Formz.validate([newName, state.email, state.password, state.passwordConfirmation])
    );
  }

  void onEmailChanged(String value) {
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([state.fullName, newEmail, state.password, state.passwordConfirmation])
    );
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.fullName, state.email, newPassword, state.passwordConfirmation])
    );
  }

  void onPasswordConfirmationChanged(String value) {
    final newPasswordConfirmation = PasswordConfirmation.dirty(password: state.password.value, value: value);

    state = state.copyWith(
      passwordConfirmation: newPasswordConfirmation,
      isValid: Formz.validate([state.fullName, state.email, state.password, newPasswordConfirmation])
    );
  }

  void onFormSubmit() async {
    _touchFields();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await registerUserCallback(state.fullName.value, state.email.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  void _touchFields() {
    final fullName = Name.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final passwordConfirmation = PasswordConfirmation.dirty(
      password: password.value, 
      value: state.passwordConfirmation.value
    );

    state = state.copyWith(
      isFormPosted: true,
      fullName: fullName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      isValid: Formz.validate([fullName, email, password, passwordConfirmation])
    );
  }
}

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name fullName;
  final Email email;
  final Password password;
  final PasswordConfirmation passwordConfirmation;

  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.fullName = const Name.pure(),
    this.email = const Email.pure(), 
    this.password = const Password.pure(),
    this.passwordConfirmation = const PasswordConfirmation.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? fullName,
    Email? email,
    Password? password,
    PasswordConfirmation? passwordConfirmation,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }

  @override
  String toString() {
    return '''RegisterFormState {
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      fullName: $fullName,
      email: $email,
      password: $password,
      passwordConfirmation: $passwordConfirmation,
    }''';
  }
}