import 'dart:convert';

import 'package:app_essentials/core/interfaces/repositories/user_repository.dart';
import 'package:app_essentials/core/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the user object in local storage using SharedPreferences.
class UserManager implements IUserRepository<User> {
  static final UserManager _singleton = UserManager._internal();
  SharedPreferences? _sharedPreferences;

  /// Constructs a new instance of [UserManager].
  factory UserManager() {
    return _singleton;
  }

  UserManager._internal();

  static const String _keyUser = '_keyUser';

  /// Retrieves the user object from local storage.
  ///
  /// Returns the [User] object if it exists in storage, otherwise returns null.
  @override
  Future<User?> getUser() async {
    final savedUserString = (await sharedPreferences).getString(_keyUser) ?? '';
    return savedUserString.isNotEmpty
        ? User.fromJson(json.decode(savedUserString))
        : null;
  }

  /// Saves the user object to local storage.
  ///
  /// Returns true if the user object is successfully saved, false otherwise.
  @override
  Future<bool> saveUser(User user) async {
    return (await sharedPreferences).setString(
      _keyUser,
      json.encode(user.toJson()),
    );
  }

  /// Updates the user object in local storage.
  ///
  /// Returns true if the user object is successfully updated, false otherwise.
  @override
  Future<bool> updateUser(User newUser) async {
    final user = await getUser();
    if (user != null) {
      if (newUser.id != null) {
        user.id = newUser.id;
      }
      if (newUser.name != null) {
        user.name = newUser.name;
      }
      await saveUser(user);
      return true;
    }
    return false;
  }

  /// Retrieves the SharedPreferences instance.
  ///
  /// Initializes and caches the SharedPreferences instance if it hasn't been accessed before.
  Future<SharedPreferences> get sharedPreferences async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }
}
