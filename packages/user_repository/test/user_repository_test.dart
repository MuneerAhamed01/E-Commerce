import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  group('UserRepository', () {
    late FakeFirebaseFirestore firestore;
    late InMemoryStorage storage;
    late UserRepository repository;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      storage = InMemoryStorage();
      repository = UserRepository(firestore: firestore, storage: storage);
    });

    test('getUser returns null when document missing', () async {
      final user = await repository.getUser('missing');
      expect(user, isNull);
    });

    test('getUser reads Firestore and caches profile', () async {
      await firestore.collection('users').doc('uid-1').set({
        'email': 'user@example.com',
        'displayName': 'Jane Doe',
        'role': 'customer',
        'orderCount': 0,
        'fcmTokens': <String>[],
        'preferences': {
          'notificationsEnabled': true,
          'marketingOptIn': false,
        },
      });

      final user = await repository.getUser('uid-1');
      expect(user?.email, 'user@example.com');

      final cached = await repository.getCachedUser('uid-1');
      expect(cached?.displayName, 'Jane Doe');
      expect(await repository.getLastCachedUserId(), 'uid-1');
    });

    test('ensureUserDocument creates profile when missing', () async {
      final user = await repository.ensureUserDocument(
        userId: 'uid-2',
        email: 'new@example.com',
        displayName: 'New User',
      );

      expect(user.id, 'uid-2');
      expect(user.email, 'new@example.com');

      final snapshot = await firestore.collection('users').doc('uid-2').get();
      expect(snapshot.exists, isTrue);
    });

    test('clearCache removes cached user', () async {
      await repository.ensureUserDocument(
        userId: 'uid-3',
        email: 'user@example.com',
      );
      await repository.clearCache(userId: 'uid-3');

      expect(await repository.getCachedUser('uid-3'), isNull);
      expect(await repository.getLastCachedUserId(), isNull);
    });

    test('getLastCachedUser returns cached profile', () async {
      await repository.ensureUserDocument(
        userId: 'uid-4',
        email: 'cached@example.com',
      );

      final cached = await repository.getLastCachedUser();
      expect(cached?.email, 'cached@example.com');
    });
  });
}
