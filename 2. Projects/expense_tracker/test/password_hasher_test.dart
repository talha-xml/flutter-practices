import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/services/password_hasher.dart';
import 'package:expense_tracker/screens/auth_screen.dart';

void main() {
  group('PasswordHasher Tests', () {
    test('generateSalt returns non-empty base64 string', () {
      final salt1 = PasswordHasher.generateSalt();
      final salt2 = PasswordHasher.generateSalt();

      expect(salt1, isNotEmpty);
      expect(salt2, isNotEmpty);
      expect(salt1, isNot(equals(salt2)));
    });

    test('hashPassword produces consistent SHA-256 hex string', () {
      const password = 'TestPassword123!';
      const salt = 'random_salt_123';

      final hash1 = PasswordHasher.hashPassword(password, salt);
      final hash2 = PasswordHasher.hashPassword(password, salt);

      expect(hash1, equals(hash2));
      expect(hash1.length, equals(64)); // SHA-256 output length in hex
    });
  });

  group('Regex Tests', () {
    test('emailRegex validates standard email formats', () {
      expect(emailRegex.hasMatch('user@example.com'), isTrue);
      expect(emailRegex.hasMatch('invalid-email'), isFalse);
      expect(emailRegex.hasMatch('user@domain'), isFalse);
    });

    test('passwordRegex validates complexity requirements', () {
      expect(passwordRegex.hasMatch('StrongPass1!'), isTrue);
      expect(passwordRegex.hasMatch('weak'), isFalse); // Too short
      expect(passwordRegex.hasMatch('alllowercase1!'), isFalse); // No uppercase
      expect(passwordRegex.hasMatch('ALLUPPERCASE1!'), isFalse); // No lowercase
      expect(passwordRegex.hasMatch('NoSpecialChar12'), isFalse); // No special char
    });
  });
}

