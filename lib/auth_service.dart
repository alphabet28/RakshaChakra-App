import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Registers a new user with plain text password (for simplicity)
  Future<bool> registerUser(String username, String password) async {
    try {
      // Check if username already exists
      final exists = await usernameExists(username);
      if (exists) {
        throw Exception('Username already exists');
      }

      // Store user with plain text password (simple approach)
      await _firestore.collection('users').add({
        'username': username,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': null,
      });

      return true;
    } catch (e) {
      print('Firestore register error: $e');
      rethrow;
    }
  }

  /// Authenticates user with simple password verification
  Future<bool> loginWithFirestore(String username, String password) async {
    try {
      print('🔍 Attempting login for username: $username');
      
      // Find user by username
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      print('📊 Found ${query.docs.length} documents for username: $username');

      if (query.docs.isEmpty) {
        print('❌ No user found with username: $username');
        return false;
      }

      final userDoc = query.docs.first;
      final userData = userDoc.data();
      
      print('📝 User data keys: ${userData.keys.toList()}');
      print('🔐 Stored password field: ${userData['password']}');
      print('📝 Provided password: $password');
      
      // Get stored password
      final storedPassword = userData['password'] as String?;
      
      if (storedPassword == null) {
        print('❌ Invalid user data: missing password');
        return false;
      }

      print('🔍 Comparing passwords:');
      print('   Stored: "$storedPassword"');
      print('   Provided: "$password"');
      print('   Match: ${password == storedPassword}');

      // Compare passwords
      if (password == storedPassword) {
        print('✅ Password match successful!');
        // Update last login time
        await userDoc.reference.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print('📅 Last login time updated');
        return true;
      }

      print('❌ Password does not match');
      return false;
    } catch (e) {
      print('❌ Firestore login error: $e');
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

  /// Gets user data by username
  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      
      if (query.docs.isNotEmpty) {
        final userData = query.docs.first.data();
        // Remove sensitive data before returning
        userData.remove('password');
        return userData;
      }
      return null;
    } catch (e) {
      print('Firestore get user data error: $e');
      rethrow;
    }
  }
}