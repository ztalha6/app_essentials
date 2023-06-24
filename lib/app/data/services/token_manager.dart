import 'package:app_essentials/core/interfaces/repositories/token_respository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager implements ITokenRepository<String> {
  static final TokenManager _singleton = TokenManager._internal();

  factory TokenManager() {
    return _singleton;
  }

  TokenManager._internal();

  late final SharedPreferences sharedPreferences;
  final String jwtTokenKey = 'jwtTokenKey';

  @override
  Future<String> getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(jwtTokenKey)) {
      return sharedPreferences.getString(jwtTokenKey)!;
    } else {
      return '';
    }
  }

  @override
  Future<bool> setToken(String token) async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (token.isEmpty) {
      return false;
    }
    return await sharedPreferences.setString(jwtTokenKey, token);
  }
}
