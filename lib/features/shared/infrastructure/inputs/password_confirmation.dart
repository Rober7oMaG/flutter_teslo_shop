import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordConfirmationError { empty, length, format, mismatch }

// Extend FormzInput and provide the input type and error type.
class PasswordConfirmation extends FormzInput<String, PasswordConfirmationError> {
  final String password;

  // Call super.pure to represent an unmodified form input.
  const PasswordConfirmation.pure({
    this.password = ''
  }) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const PasswordConfirmation.dirty({
    required String value,
    this.password = ''
  }) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordConfirmationError.mismatch) return 'Passwords don\'t match';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PasswordConfirmationError? validator(String value) {
    if (value != password) return PasswordConfirmationError.mismatch;

    return null;
  }
}