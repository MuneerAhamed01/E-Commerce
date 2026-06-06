import 'package:authentication_client/authentication_client.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Maps [FirebaseAuthException] to [AuthFailure].
AuthFailure mapFirebaseAuthException(FirebaseAuthException exception) {
  final code = switch (exception.code) {
    'user-not-found' => AuthFailureCode.userNotFound,
    'wrong-password' => AuthFailureCode.wrongPassword,
    'invalid-credential' => AuthFailureCode.wrongPassword,
    'email-already-in-use' => AuthFailureCode.emailAlreadyInUse,
    'weak-password' => AuthFailureCode.weakPassword,
    'invalid-email' => AuthFailureCode.invalidEmail,
    'user-disabled' => AuthFailureCode.userDisabled,
    'too-many-requests' => AuthFailureCode.tooManyRequests,
    _ => AuthFailureCode.unknown,
  };

  return AuthFailure(code: code, message: _messageForCode(code));
}

/// Maps a generic error to [AuthFailure].
AuthFailure mapAuthError(Object error) {
  if (error is AuthFailure) return error;
  if (error is FirebaseAuthException) return mapFirebaseAuthException(error);
  return const AuthFailure(
    code: AuthFailureCode.unknown,
    message: 'Something went wrong. Please try again.',
  );
}

String _messageForCode(AuthFailureCode code) {
  return switch (code) {
    AuthFailureCode.userNotFound => 'No account found for this email.',
    AuthFailureCode.wrongPassword => 'Incorrect password.',
    AuthFailureCode.emailAlreadyInUse => 'An account already exists.',
    AuthFailureCode.weakPassword =>
      'Password must be at least 8 characters.',
    AuthFailureCode.invalidEmail => 'Enter a valid email address.',
    AuthFailureCode.userDisabled => 'This account has been disabled.',
    AuthFailureCode.tooManyRequests =>
      'Too many attempts. Please try again later.',
    AuthFailureCode.cancelled => 'Sign in was cancelled.',
    AuthFailureCode.unknown => 'Something went wrong. Please try again.',
  };
}
