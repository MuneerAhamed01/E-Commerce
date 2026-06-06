import 'dart:async';

import 'package:authentication_client/src/auth_failure.dart';
import 'package:authentication_client/src/auth_user.dart';
import 'package:authentication_client/src/authentication_client.dart';

/// In-memory [AuthenticationClient] for tests and previews.
class MockAuthenticationClient implements AuthenticationClient {
  MockAuthenticationClient({AuthUser? user}) : _user = user;

  final _controller = StreamController<AuthUser?>.broadcast();
  AuthUser? _user;

  @override
  Stream<AuthUser?> get user => _controller.stream;

  @override
  AuthUser? get currentUser => _user;

  /// Simulates signing in a user.
  void emitUser(AuthUser? user) {
    _user = user;
    _controller.add(user);
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    emitUser(
      AuthUser(
        id: 'mock-uid',
        email: email,
        displayName: displayName,
        providerId: 'password',
      ),
    );
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (password == 'wrongpass') {
      throw const AuthFailure(
        code: AuthFailureCode.wrongPassword,
        message: 'Incorrect password.',
      );
    }
    emitUser(AuthUser(id: 'mock-uid', email: email, providerId: 'password'));
  }

  @override
  Future<void> signInWithGoogle() async {
    emitUser(
      const AuthUser(
        id: 'mock-google-uid',
        email: 'google@example.com',
        providerId: 'google.com',
      ),
    );
  }

  @override
  Future<void> signInWithApple() async {
    emitUser(
      const AuthUser(
        id: 'mock-apple-uid',
        email: 'apple@example.com',
        providerId: 'apple.com',
      ),
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {}

  @override
  Future<void> signOut() async {
    emitUser(null);
  }

  /// Closes the underlying stream controller.
  Future<void> close() => _controller.close();
}
