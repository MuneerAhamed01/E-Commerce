import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_authentication_client/src/firebase_auth_exception_mapper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Maps a Firebase [firebase_auth.User] to [AuthUser].
AuthUser? mapFirebaseUser(firebase_auth.User? user) {
  if (user == null) return null;
  return AuthUser(
    id: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    emailVerified: user.emailVerified,
    providerId: user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : null,
  );
}

/// [AuthenticationClient] backed by Firebase Auth.
class FirebaseAuthenticationClient implements AuthenticationClient {
  FirebaseAuthenticationClient({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<AuthUser?> get user =>
      _firebaseAuth.authStateChanges().map(mapFirebaseUser);

  @override
  AuthUser? get currentUser => mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
        await credential.user?.reload();
      }
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw mapFirebaseAuthException(error);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw mapFirebaseAuthException(error);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure(
          code: AuthFailureCode.cancelled,
          message: 'Sign in was cancelled.',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on AuthFailure {
      rethrow;
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw mapFirebaseAuthException(error);
    } catch (error) {
      throw mapAuthError(error);
    }
  }

  @override
  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = firebase_auth.OAuthProvider('apple.com')
          .credential(
            idToken: appleCredential.identityToken,
            accessToken: appleCredential.authorizationCode,
          );

      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );

      final fullName = appleCredential.givenName != null
          ? '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'
                .trim()
          : null;
      if (fullName != null &&
          fullName.isNotEmpty &&
          userCredential.user?.displayName == null) {
        await userCredential.user?.updateDisplayName(fullName);
        await userCredential.user?.reload();
      }
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const AuthFailure(
          code: AuthFailureCode.cancelled,
          message: 'Sign in was cancelled.',
        );
      }
      throw mapAuthError(error);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw mapFirebaseAuthException(error);
    } catch (error) {
      throw mapAuthError(error);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw mapFirebaseAuthException(error);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
