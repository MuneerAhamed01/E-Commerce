import 'package:form_inputs/form_inputs.dart';

/// Maps [Email] validation errors to user-facing copy.
String? emailErrorText(Email email) {
  if (email.isPure) return null;
  return switch (email.error) {
    EmailValidationError.empty => 'Email is required',
    EmailValidationError.invalid => 'Enter a valid email address',
    null => null,
  };
}

/// Maps [Password] validation errors to user-facing copy.
String? passwordErrorText(Password password) {
  if (password.isPure) return null;
  return switch (password.error) {
    PasswordValidationError.empty => 'Password is required',
    PasswordValidationError.tooShort => 'Password must be at least 8 characters',
    null => null,
  };
}

/// Maps [ConfirmedPassword] validation errors to user-facing copy.
String? confirmedPasswordErrorText(ConfirmedPassword password) {
  if (password.isPure) return null;
  return switch (password.error) {
    ConfirmedPasswordValidationError.empty => 'Please confirm your password',
    ConfirmedPasswordValidationError.mismatch => 'Passwords do not match',
    null => null,
  };
}

/// Maps [DisplayName] validation errors to user-facing copy.
String? displayNameErrorText(DisplayName name) {
  if (name.isPure) return null;
  return switch (name.error) {
    DisplayNameValidationError.empty => 'Name is required',
    DisplayNameValidationError.tooShort => 'Name must be at least 2 characters',
    null => null,
  };
}
