import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:user_repository/src/user.dart';
import 'package:user_repository/src/user_preferences.dart';

/// Thrown when a user profile cannot be loaded or saved.
class UserRepositoryException implements Exception {
  const UserRepositoryException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() {
    if (cause != null) {
      return 'UserRepositoryException: $message ($cause)';
    }
    return 'UserRepositoryException: $message';
  }
}

/// Reads and caches Firestore user profiles.
class UserRepository {
  UserRepository({
    required FirebaseFirestore firestore,
    required PersistentStorage storage,
  }) : _firestore = firestore,
       _storage = storage;

  final FirebaseFirestore _firestore;
  final PersistentStorage _storage;

  static const _lastUserIdKey = 'last_user_id';
  static String _cacheKey(String userId) => 'cached_user_$userId';

  /// Returns the last cached user id for fast cold-start hydration.
  Future<String?> getLastCachedUserId() => _storage.read(_lastUserIdKey);

  /// Returns a cached [User] without hitting Firestore.
  Future<User?> getCachedUser(String userId) async {
    final cached = await _storage.read(_cacheKey(userId));
    if (cached == null) return null;
    return User.fromCacheJson(cached);
  }

  /// Loads the cached user for the last known session, if any.
  Future<User?> getLastCachedUser() async {
    final userId = await getLastCachedUserId();
    if (userId == null) return null;
    return getCachedUser(userId);
  }

  /// Fetches a user profile from Firestore and updates the local cache.
  ///
  /// Returns null when the document is missing or cannot be read yet (e.g.
  /// auth token still propagating after sign-up).
  Future<User?> getUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(User.collectionName)
          .doc(userId)
          .get();

      if (!snapshot.exists) return null;

      final user = User.fromFirestore(snapshot);
      await _cacheUser(user);
      return user;
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied' ||
          error.code == 'unauthenticated' ||
          error.code == 'unavailable') {
        return null;
      }
      rethrow;
    }
  }

  /// Loads an existing profile or creates one for a newly signed-in user.
  ///
  /// Retries briefly so Firestore sees the auth token right after sign-up.
  Future<User> loadOrCreateUser({
    required String userId,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phone,
  }) async {
    const maxAttempts = 3;
    Object? lastError;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final existing = await getUser(userId);
        if (existing != null) return existing;

        return await ensureUserDocument(
          userId: userId,
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
          phone: phone,
        );
      } catch (error) {
        lastError = error;
        if (attempt < maxAttempts - 1) {
          await Future<void>.delayed(
            Duration(milliseconds: 250 * (attempt + 1)),
          );
        }
      }
    }

    throw UserRepositoryException(
      'Could not load or create user profile.',
      cause: lastError,
    );
  }

  /// Ensures a user document exists (dev fallback when Cloud Function
  /// is not deployed).
  Future<User> ensureUserDocument({
    required String userId,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phone,
  }) async {
    final docRef = _firestore.collection(User.collectionName).doc(userId);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final user = User.fromFirestore(snapshot);
      await _cacheUser(user);
      return user;
    }

    final now = FieldValue.serverTimestamp();
    final data = {
      'id': userId,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phone': phone,
      'role': 'customer',
      'orderCount': 0,
      'defaultAddressId': null,
      'fcmTokens': <String>[],
      'preferences': const UserPreferences().toJson(),
      'createdAt': now,
      'updatedAt': now,
    };

    await docRef.set(data, SetOptions(merge: true));
    final created = await docRef.get();
    final user = User.fromFirestore(created);
    await _cacheUser(user);
    return user;
  }

  /// Updates profile fields and refreshes the local cache.
  Future<User> updateUser({
    required String userId,
    String? displayName,
    String? phone,
    UserPreferences? preferences,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (displayName != null) updates['displayName'] = displayName;
    if (phone != null) updates['phone'] = phone;
    if (preferences != null) updates['preferences'] = preferences.toJson();

    final docRef = _firestore.collection(User.collectionName).doc(userId);
    await docRef.set(updates, SetOptions(merge: true));

    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      throw const UserRepositoryException('User profile not found.');
    }

    final user = User.fromFirestore(snapshot);
    await _cacheUser(user);
    return user;
  }

  /// Clears cached profile data on sign-out.
  Future<void> clearCache({String? userId}) async {
    if (userId != null) {
      await _storage.delete(_cacheKey(userId));
    }
    await _storage.delete(_lastUserIdKey);
  }

  Future<void> _cacheUser(User user) async {
    await _storage.write(_cacheKey(user.id), user.toCacheJson());
    await _storage.write(_lastUserIdKey, user.id);
  }
}
