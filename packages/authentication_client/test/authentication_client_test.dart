import 'package:authentication_client/authentication_client.dart';
import 'package:test/test.dart';

void main() {
  group('MockAuthenticationClient', () {
    late MockAuthenticationClient client;

    setUp(() {
      client = MockAuthenticationClient();
    });

    tearDown(() => client.close());

    test('starts unauthenticated', () {
      expect(client.currentUser, isNull);
    });

    test('signInWithEmailAndPassword emits user', () async {
      await client.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );
      expect(client.currentUser?.email, 'user@example.com');
    });

    test('wrong password throws AuthFailure', () async {
      expect(
        () => client.signInWithEmailAndPassword(
          email: 'user@example.com',
          password: 'wrongpass',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (f) => f.code,
            'code',
            AuthFailureCode.wrongPassword,
          ),
        ),
      );
    });

    test('signOut clears user', () async {
      await client.signInWithGoogle();
      await client.signOut();
      expect(client.currentUser, isNull);
    });

    test('user stream emits on sign in', () async {
      final events = <AuthUser?>[];
      final subscription = client.user.listen(events.add);

      await client.signInWithApple();
      await Future<void>.delayed(Duration.zero);

      expect(events.last?.providerId, 'apple.com');
      await subscription.cancel();
    });
  });
}
