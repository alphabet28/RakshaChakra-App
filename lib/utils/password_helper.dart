import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Utility to help generate password hashes for manual database updates
class PasswordHelper {
  /// Generate SHA-256 hash of a password
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate hash for common test passwords
  static void generateTestHashes() {
    print('🔐 Password Hash Generator');
    print('=' * 50);
    
    final testPasswords = [
      'TestPass123!',
      'admin123',
      'password123',
      'alice123',
      'bob123',
      'charlie123',
    ];

    for (final password in testPasswords) {
      final hash = hashPassword(password);
      print('Password: $password');
      print('Hash: $hash');
      print('─' * 50);
    }
  }

  /// Generate hash for a specific password
  static void generateHashForPassword(String password) {
    final hash = hashPassword(password);
    print('🔐 Password Hash for: $password');
    print('Hash: $hash');
    print('Copy this hash to your Firestore database in the "passwordHash" field');
  }
} 