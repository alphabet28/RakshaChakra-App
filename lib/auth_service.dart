import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Hashes the password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Registers a new user with hashed password
  Future<bool> registerUser(String username, String password) async {
    try {
      final exists = await usernameExists(username);
      if (exists) throw Exception('Username already exists');

      final hashedPassword = hashPassword(password);

      await _firestore.collection('users').add({
        'username': username,
        'passwordHash': hashedPassword,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': null,
      });

      return true;
    } catch (e) {
      print('Firestore register error: $e');
      rethrow;
    }
  }

  /// Authenticates user by comparing password hash
  Future<bool> loginWithFirestore(String username, String password) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (query.docs.isEmpty) return false;

      final userDoc = query.docs.first;
      final userData = userDoc.data();

      final storedPasswordHash = userData['passwordHash'] as String?;
      if (storedPasswordHash == null) return false;

      final enteredPasswordHash = hashPassword(password);

      if (enteredPasswordHash == storedPasswordHash) {
        await userDoc.reference.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        return true;
      }

      return false;
    } catch (e) {
      print('Firestore login error: $e');
      rethrow;
    }
  }

  /// Checks if a username already exists in Firestore
  Future<bool> usernameExists(String username) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      print('Firestore username check error: $e');
      rethrow;
    }
  }

  /// Gets user data by username (excluding password hash)
  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      
      if (query.docs.isNotEmpty) {
        final userData = query.docs.first.data();
        userData.remove('passwordHash');
        return userData;
      }
      return null;
    } catch (e) {
      print('Firestore get user data error: $e');
      rethrow;
    }
  }
}