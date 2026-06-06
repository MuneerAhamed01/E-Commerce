import 'package:authentication_client/authentication_client.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  group('mapFirebaseAuthException', () {
    test('maps user-not-found', () {
      final failure = mapFirebaseAuthException(
        firebase_auth.FirebaseAuthException(code: 'user-not-found'),
      );
      expect(failure.code, AuthFailureCode.userNotFound);
    });

    test('maps email-already-in-use', () {
      final failure = mapFirebaseAuthException(
        firebase_auth.FirebaseAuthException(code: 'email-already-in-use'),
      );
      expect(failure.code, AuthFailureCode.emailAlreadyInUse);
    });
  });

  group('FirebaseAuthenticationClient', () {
    late MockFirebaseAuth mockAuth;
    late MockGoogleSignIn mockGoogleSignIn;
    late FirebaseAuthenticationClient client;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      client = FirebaseAuthenticationClient(
        firebaseAuth: mockAuth,
        googleSignIn: mockGoogleSignIn,
      );
    });

    test('currentUser is null when signed out', () {
      expect(client.currentUser, isNull);
    });

    test('signInWithEmailAndPassword signs in mock user', () async {
      mockAuth = MockFirebaseAuth(
        signedIn: false,
        mockUser: MockUser(
          uid: 'uid-1',
          email: 'user@example.com',
          isEmailVerified: true,
        ),
      );
      client = FirebaseAuthenticationClient(
        firebaseAuth: mockAuth,
        googleSignIn: mockGoogleSignIn,
      );

      await client.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );

      expect(client.currentUser?.email, 'user@example.com');
    });

    test('signOut clears session', () async {
      mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'uid-1', email: 'user@example.com'),
      );
      client = FirebaseAuthenticationClient(
        firebaseAuth: mockAuth,
        googleSignIn: mockGoogleSignIn,
      );

      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      await client.signOut();
      expect(client.currentUser, isNull);
    });

    test('signInWithGoogle cancelled throws AuthFailure', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      expect(
        () => client.signInWithGoogle(),
        throwsA(
          isA<AuthFailure>().having(
            (f) => f.code,
            'code',
            AuthFailureCode.cancelled,
          ),
        ),
      );
    });

    test('sendPasswordResetEmail completes for signed-out user', () async {
      await client.sendPasswordResetEmail(email: 'user@example.com');
    });
  });
}
