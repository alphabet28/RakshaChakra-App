import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _usernameToEmail(String username) {
    // Clean the username to make it email-safe
    final cleanUsername = username
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), ''); // Remove spaces
    
    // Ensure we have a valid username
    if (cleanUsername.isEmpty) {
      throw Exception('Username cannot be empty after cleaning');
    }
    
    // Use a real domain for testing
    return '$cleanUsername@gmail.com';
  }

  // Test function to verify Firebase Auth is working
  Future<void> testFirebaseConnection() async {
    try {
      print('Testing Firebase connection...');
      print('Firebase Auth instance: $_auth');
      print('Current user: ${_auth.currentUser}');
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase connection test failed: $e');
      rethrow;
    }
  }

  Future<bool> usernameExists(String username) async {
    try {
      final email = _usernameToEmail(username);
      print('Checking if username exists: $email');
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: 'dummyPassword123!',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print('Username check error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        return false;
      } else if (e.code == 'wrong-password') {
        return true;
      } else {
        rethrow;
      }
    }
  }

  Future<UserCredential> signUp(String username, String password) async {
    try {
      // Test Firebase connection first
      await testFirebaseConnection();
      
      final email = _usernameToEmail(username);
      print('Creating user with email: $email');
      print('Password length: ${password.length}');
      
      // Create the user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('User created successfully: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      print('Error details: ${e.toString()}');
      rethrow;
    } catch (e) {
      print('General Error: $e');
      print('Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  Future<UserCredential> signIn(String username, String password) async {
    final email = _usernameToEmail(username);
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get userChanges => _auth.authStateChanges();

  String? validatePassword(String password) {
    if (password.length < 10) return 'Password must be at least 10 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Must have uppercase letter.';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Must have lowercase letter.';
    if (!RegExp(r'\d').hasMatch(password)) return 'Must have a number.';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return 'Must have a special character.';
    return null;
  }
}