import 'package:app_essentials/core/interfaces/repositories/token_respository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the authentication token using SharedPreferences.
///
/// This class implements the `ITokenRepository` interface to provide methods
/// for retrieving and setting the authentication token.
class TokenManager implements ITokenRepository<String> {
  static const String jwtTokenKey = 'jwtTokenKey';
  late final SharedPreferences sharedPreferences;

  /// Initializes a new instance of the [TokenManager] class.
  ///
  /// Retrieves the [SharedPreferences] instance for token management.
  TokenManager() {
    initializeSharedPreferences();
  }

  /// Initializes the [SharedPreferences] instance for token management.
  Future<void> initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Retrieves the authentication token.
  ///
  /// Returns the authentication token stored in SharedPreferences,
  /// or an empty string if the token is not found.
  @override
  Future<String> getToken() async {
    return sharedPreferences.getString(jwtTokenKey) ?? '';
  }

  /// Sets the authentication token.
  ///
  /// If the provided token is empty, returns `false`.
  /// Otherwise, stores the token in SharedPreferences and returns `true`.
  @override
  Future<bool> setToken(String token) async {
    if (isValidToken(token)) {
      return await sharedPreferences.setString(jwtTokenKey, token);
    }
    return false;
  }

  /// Checks if the provided token is valid.
  ///
  /// Returns `true` if the token is not empty, `false` otherwise.
  bool isValidToken(String token) {
    return token.isNotEmpty;
  }
}
