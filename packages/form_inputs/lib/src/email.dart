import 'package:formz/formz.dart';

/// Validation errors for [Email].
enum EmailValidationError {
  /// Email field is empty.
  empty,

  /// Email format is invalid.
  invalid,
}

/// Reusable email Formz input.
class Email extends FormzInput<String, EmailValidationError> {
  /// Creates a pure [Email] input.
  const Email.pure() : super.pure('');

  /// Creates a dirty [Email] input with [value].
  const Email.dirty([super.value = '']) : super.dirty();

  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}"
    r'[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  @override
  EmailValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}
