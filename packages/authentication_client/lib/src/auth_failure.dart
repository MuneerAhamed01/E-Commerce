import 'package:equatable/equatable.dart';

/// Typed authentication failures for UI-ready error messages.
enum AuthFailureCode {
  /// No account found for the email.
  userNotFound,

  /// Incorrect password.
  wrongPassword,

  /// Email already registered.
  emailAlreadyInUse,

  /// Password does not meet requirements.
  weakPassword,

  /// Invalid email format.
  invalidEmail,

  /// Account has been disabled.
  userDisabled,

  /// Too many failed attempts.
  tooManyRequests,

  /// Social sign-in was cancelled by the user.
  cancelled,

  /// Network or unknown error.
  unknown,
}

/// Authentication failure with a user-facing message.
class AuthFailure extends Equatable implements Exception {
  const AuthFailure({
    required this.code,
    required this.message,
  });

  /// Failure category.
  final AuthFailureCode code;

  /// User-facing error message.
  final String message;

  @override
  List<Object?> get props => [code, message];

  @override
  String toString() => 'AuthFailure($code): $message';
}
