import 'package:persistent_storage/src/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [PersistentStorage] backed by [SharedPreferences].
class SharedPreferencesStorage implements PersistentStorage {
  SharedPreferencesStorage(this._preferences);

  final SharedPreferences _preferences;

  /// Creates storage using the platform [SharedPreferences] instance.
  static Future<SharedPreferencesStorage> create() async {
    final preferences = await SharedPreferences.getInstance();
    return SharedPreferencesStorage(preferences);
  }

  @override
  Future<String?> read(String key) async => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) async {
    await _preferences.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }
}
