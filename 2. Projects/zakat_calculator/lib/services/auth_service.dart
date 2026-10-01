import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import '../utils/password_hasher.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> registerUser({
    required User user,
    required String password,
  }) async {
    final salt = PasswordHasher.generateSalt();
    final passwordHash = PasswordHasher.hashPassword(password, salt);
    await _secureStorage.write(key: 'user_name', value: user.name);
    await _secureStorage.write(key: 'user_email', value: user.email);
    await _secureStorage.write(key: 'password_salt', value: salt);
    await _secureStorage.write(key: 'password_hash', value: passwordHash);
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final savedEmail = await _secureStorage.read(key: 'user_email');
    final savedSalt = await _secureStorage.read(key: 'password_salt');
    final savedHash = await _secureStorage.read(key: 'password_hash');
    if (savedEmail == null || savedSalt == null || savedHash == null) {
      return null;
    }
    if (email != savedEmail) {
      return null;
    }

    final enteredHash = PasswordHasher.hashPassword(password, savedSalt);

    if (enteredHash != savedHash) {
      return null;
    }

    final savedName = await _secureStorage.read(key: 'user_name');

    return User(name: savedName ?? '', email: savedEmail);
  }
}
