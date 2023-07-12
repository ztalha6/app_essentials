import 'package:app_essentials/core/interfaces/services/app_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [SharedPreferencesService] using the Flutter-specific SharedPreferences package.
/// This class provides methods to set and retrieve boolean values in SharedPreferences.
class FlutterSharedPreferencesService implements SharedPreferencesService {
  /// Retrieves an instance of SharedPreferences.
  /// Returns a [Future] that resolves to an instance of SharedPreferences.
  Future<SharedPreferences> _getInstance() async {
    return SharedPreferences.getInstance();
  }

  /// Sets a boolean value in SharedPreferences associated with the given [key].
  /// The [key] is used to identify the value.
  /// The [value] is the boolean value to be set.
  /// Throws an exception if there is an error accessing or setting the value in SharedPreferences.
  @override
  Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await _getInstance();
    await prefs.setBool(key, value);
  }

  /// Retrieves a boolean value from SharedPreferences associated with the given [key].
  /// The [key] is used to identify the value.
  /// Returns the retrieved boolean value if it exists, otherwise returns `false`.
  /// Throws an exception if there is an error accessing the value in SharedPreferences.
  @override
  Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await _getInstance();
    return prefs.getBool(key) ?? false;
  }
}

/// A service class responsible for managing the first start key in SharedPreferences.
class AppService {
  final String _firstStartKey = 'firstStart';
  final SharedPreferencesService _sharedPreferencesService;

  /// Constructs an [AppService] instance with a [SharedPreferencesService] dependency.
  /// The [sharedPreferencesService] is used to interact with SharedPreferences.
  AppService(this._sharedPreferencesService);

  /// Sets the first start key in SharedPreferences to `true`.
  /// This method uses the [SharedPreferencesService] to set the value.
  /// Throws an exception if there is an error accessing or setting the value in SharedPreferences.
  Future<void> setFirstStart() async {
    await _sharedPreferencesService.setBool(_firstStartKey, true);
  }

  /// Retrieves the value of the first start key from SharedPreferences.
  /// This method uses the [SharedPreferencesService] to retrieve the value.
  /// Returns `true` if the value exists and is `true`, otherwise returns `false`.
  /// Throws an exception if there is an error accessing the value in SharedPreferences.
  Future<bool> getFirstStart() async {
    return await _sharedPreferencesService.getBool(_firstStartKey);
  }
}
