import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/utils/password_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  print('🚀 Generating password hash for testuser');
  print('=' * 50);
  
  // Generate hash for TestPass123!
  PasswordHelper.generateHashForPassword('TestPass123!');
  
  print('');
  print('📝 Instructions:');
  print('1. Copy the hash above');
  print('2. Go to your Firestore database');
  print('3. Find the user document for "testuser"');
  print('4. Replace the "password" field with "passwordHash"');
  print('5. Paste the hash as the value');
  print('6. Delete the old "password" field');
  print('');
  print('✅ After this, your login will work with hashed passwords!');
} 