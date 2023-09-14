/// A contract defining the interface for managing SharedPreferences.
/// Implementing classes must provide methods to set and retrieve boolean values.
abstract class SharedPreferencesService {
  /// Sets a boolean value in SharedPreferences associated with the given [key].
  Future<void> setBool(String key, bool value);

  /// Retrieves a boolean value from SharedPreferences associated with the given [key].
  Future<bool> getBool(String key);
}
