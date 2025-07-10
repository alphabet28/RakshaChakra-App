import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/utils/quick_migrate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  print('🚀 Starting testuser migration...');
  print('=' * 50);
  
  // Check current status
  await QuickMigrate.checkTestUserStatus();
  print('');
  
  // Migrate the user
  await QuickMigrate.migrateTestUser();
  print('');
  
  // Check status again
  await QuickMigrate.checkTestUserStatus();
  print('');
  
  print('✅ Migration test completed!');
  print('🔐 You can now login with: testuser / TestPass123!');
} 