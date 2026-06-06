import 'package:formz/formz.dart';

/// Validation errors for [DisplayName].
enum DisplayNameValidationError {
  /// Display name field is empty.
  empty,

  /// Display name is too short.
  tooShort,
}

/// Display name Formz input for sign-up.
class DisplayName extends FormzInput<String, DisplayNameValidationError> {
  /// Creates a pure [DisplayName] input.
  const DisplayName.pure() : super.pure('');

  /// Creates a dirty [DisplayName] input with [value].
  const DisplayName.dirty([super.value = '']) : super.dirty();

  /// Minimum display name length.
  static const minLength = 2;

  @override
  DisplayNameValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return DisplayNameValidationError.empty;
    }
    if (value.trim().length < minLength) {
      return DisplayNameValidationError.tooShort;
    }
    return null;
  }
}
