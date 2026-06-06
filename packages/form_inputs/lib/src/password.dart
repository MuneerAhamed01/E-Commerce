import 'package:formz/formz.dart';

/// Validation errors for [Password].
enum PasswordValidationError {
  /// Password field is empty.
  empty,

  /// Password is too short.
  tooShort,
}

/// Reusable password Formz input.
class Password extends FormzInput<String, PasswordValidationError> {
  /// Creates a pure [Password] input.
  const Password.pure() : super.pure('');

  /// Creates a dirty [Password] input with [value].
  const Password.dirty([super.value = '']) : super.dirty();

  /// Minimum password length for sign-up.
  static const minLength = 8;

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return PasswordValidationError.empty;
    if (value.length < minLength) return PasswordValidationError.tooShort;
    return null;
  }
}
