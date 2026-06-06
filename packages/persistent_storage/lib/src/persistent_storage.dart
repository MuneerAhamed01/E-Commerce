/// Abstract key-value store for caching app data locally.
abstract class PersistentStorage {
  /// Reads a string value for [key], or null if absent.
  Future<String?> read(String key);

  /// Writes [value] for [key].
  Future<void> write(String key, String value);

  /// Removes the value for [key].
  Future<void> delete(String key);

  /// Removes all stored values.
  Future<void> clear();
}
