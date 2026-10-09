import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/password_hasher.dart';
import 'user_storage.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final UserStorage _userStorage = UserStorage();

  Future<bool> registerUser({
    required User user,
    required String password,
  }) async {
    final existingUser = await _userStorage.findUserByEmail(user.email);

    if (existingUser != null) {
      return false;
    }

    final salt = PasswordHasher.generateSalt();
    final passwordHash = PasswordHasher.hashPassword(password, salt);
    await _secureStorage.write(key: 'password_salt_${user.id}', value: salt);
    await _secureStorage.write(
      key: 'password_hash_${user.id}',
      value: passwordHash,
    );

    await _userStorage.saveUser(user);
    return true;
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final user = await _userStorage.findUserByEmail(email);

    if (user == null) {
      return null;
    }

    final savedSalt = await _secureStorage.read(
      key: 'password_salt_${user.id}',
    );

    final savedHash = await _secureStorage.read(
      key: 'password_hash_${user.id}',
    );

    if (savedSalt == null || savedHash == null) {
      return null;
    }

    final enteredHash = PasswordHasher.hashPassword(password, savedSalt);

    if (enteredHash != savedHash) {
      return null;
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('logged_in_user_id', user.id);
    return user;
  }

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString('logged_in_user_id');
    return userId != null;
  }

  Future<User?> getLoggedInUser() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getString('logged_in_user_id');

    if (userId == null) return null;

    final user = await _userStorage.findUserById(userId);

    if (user == null) {
      await preferences.remove('logged_in_user_id');
    }

    return user;
  }

  Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('logged_in_user_id');
  }
}
