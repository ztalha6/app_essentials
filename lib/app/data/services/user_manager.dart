import 'dart:convert';

import 'package:app_essentials/core/interfaces/repositories/user_repository.dart';
import 'package:app_essentials/app/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager implements IUserRepository<User> {
  static final UserManager _singleton = UserManager._internal();

  factory UserManager() {
    return _singleton;
  }

  UserManager._internal();

  static const String _keyUser = '_keyUser';

  @override
  Future<User?> getUser() async {
    final String savedUserString =
        (await SharedPreferences.getInstance()).getString(_keyUser) ?? '';
    return savedUserString.isNotEmpty
        ? User.fromJson(json.decode(savedUserString))
        : null;
  }

  @override
  Future<bool> saveUser(User user) async {
    return (await SharedPreferences.getInstance()).setString(
      _keyUser,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<bool> updateUser(User newUser) async {
    final User? user = await getUser();
    if (user != null) {
      if (newUser.id != null) {
        user.id = newUser.id;
      }
      if (newUser.name != null) {
        user.name = newUser.name;
      }
      saveUser(user);
      return true;
    }
    return false;
  }
}
