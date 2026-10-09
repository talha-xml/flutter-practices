import 'package:hive_flutter/hive_flutter.dart';

import '../models/user.dart';

class UserStorage {
  static const String _boxName = 'users';

  Future<Box> _openBox() async {
    return Hive.openBox(_boxName);
  }

  Future<User?> findUserByEmail(String email) async {
    final box = await _openBox();
    final normalizedEmail = email.toLowerCase().trim();
    for (final key in box.keys) {
      final data = Map<String, dynamic>.from(box.get(key) as Map);
      if (data['email'] == normalizedEmail) {
        return User(
          id: data['id'] as String,
          name: data['name'] as String,
          email: data['email'] as String,
        );
      }
    }

    return null;
  }

  Future<User?> findUserById(String id) async {
    final box = await _openBox();
    final data = box.get(id);
    if (data == null) return null;
    final userData = Map<String, dynamic>.from(data as Map);
    return User(
      id: userData['id'] as String,
      name: userData['name'] as String,
      email: userData['email'] as String,
    );
  }

  Future<void> saveUser(User user) async {
    final box = await _openBox();
    await box.put(user.id, {
      'id': user.id,
      'name': user.name,
      'email': user.email.toLowerCase().trim(),
    });
  }
}
