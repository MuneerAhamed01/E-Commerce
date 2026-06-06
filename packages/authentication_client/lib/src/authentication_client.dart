import 'package:authentication_client/src/auth_user.dart';

/// Contract for authentication operations.
///
/// Implementations must not leak platform-specific types.
abstract class AuthenticationClient {
  /// Stream of auth state changes. Emits null when signed out.
  Stream<AuthUser?> get user;

  /// Currently signed-in user, or null.
  AuthUser? get currentUser;

  /// Creates a new account with email and password.
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Signs in with email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs in with Google.
  Future<void> signInWithGoogle();

  /// Signs in with Apple.
  Future<void> signInWithApple();

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail({required String email});

  /// Signs out the current user.
  Future<void> signOut();
}
