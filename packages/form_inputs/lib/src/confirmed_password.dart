import 'package:formz/formz.dart';

/// Validation errors for [ConfirmedPassword].
enum ConfirmedPasswordValidationError {
  /// Confirmation field is empty.
  empty,

  /// Confirmation does not match the original password.
  mismatch,
}

/// Password confirmation Formz input.
class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  /// Creates a pure [ConfirmedPassword] input.
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  /// Creates a dirty [ConfirmedPassword] input with [value].
  const ConfirmedPassword.dirty({
    required this.password,
    String value = '',
  }) : super.dirty(value);

  /// The original password to match against.
  final String password;

  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return ConfirmedPasswordValidationError.empty;
    }
    if (value != password) return ConfirmedPasswordValidationError.mismatch;
    return null;
  }
}
