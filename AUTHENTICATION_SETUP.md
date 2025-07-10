# Secure Authentication Setup Guide

## Overview

This banking app now implements a secure authentication system with the following features:

- ✅ **Secure Password Storage**: Passwords are hashed with SHA-256 and salted
- ✅ **Manual User Management**: Create users through admin interface
- ✅ **Firebase Integration**: Uses Firestore for user data storage
- ✅ **Login Verification**: Secure identity verification
- ✅ **Session Management**: Automatic navigation to home screen after login

## What You Can Expect

### 1. **Manual User Creation Process**

You can create users in two ways:

#### Option A: Using the Admin Screen (Recommended)
1. Run the app
2. Navigate to the admin screen
3. Fill in user details (username, password, full name, email)
4. Click "Create User"
5. The system will automatically hash and salt the password

#### Option B: Using the Setup Script
1. Import and run the `UserSetup.runSetup()` method
2. This creates sample users for testing

### 2. **Password Security**

- **Before**: Passwords stored in plain text (❌ UNSAFE)
- **After**: Passwords stored as salted SHA-256 hashes (✅ SECURE)

**How it works:**
1. When creating a user, a random 16-byte salt is generated
2. Password + salt is hashed using SHA-256
3. Both the hash and salt are stored in Firebase
4. During login, the same process is used to verify the password

### 3. **Login Flow**

1. User enters username and password
2. System finds user by username in Firestore
3. Retrieves the stored salt and password hash
4. Hashes the provided password with the stored salt
5. Compares the computed hash with the stored hash
6. If they match, user is authenticated and redirected to home screen

## Setup Instructions

### Step 1: Install Dependencies

Run this command to install the required crypto package:

```bash
flutter pub get
```

### Step 2: Firebase Configuration

Make sure your Firebase project is properly configured:

1. Create a Firebase project at https://console.firebase.google.com
2. Add your Flutter app to the project
3. Download and add the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files
4. Enable Firestore Database in your Firebase console

### Step 3: Create Initial Users

#### Method 1: Admin Screen
1. Add a route to the admin screen in your main.dart:

```dart
// Add this route to your MaterialApp
routes: {
  '/admin': (context) => const AdminScreen(),
},
```

2. Navigate to `/admin` in your app
3. Use the form to create users

#### Method 2: Setup Script
1. Import the setup script in your main.dart:

```dart
import 'utils/setup_users.dart';
```

2. Call the setup method (run this once):

```dart
// In your main() function or a setup button
await UserSetup.runSetup();
```

### Step 4: Test the Login

Use these sample credentials to test:

- **Admin User**: `admin` / `admin123`
- **Customer 1**: `customer1` / `password123`
- **Alice**: `alice` / `alice123`
- **Bob**: `bob` / `bob123`
- **Charlie**: `charlie` / `charlie123`

## Database Structure

Your Firestore will have a `users` collection with documents like this:

```json
{
  "username": "admin",
  "passwordHash": "a1b2c3d4e5f6...", // SHA-256 hash
  "salt": "random_salt_string", // 16-byte random salt
  "fullName": "System Administrator",
  "email": "admin@raksha.com",
  "role": "admin",
  "createdAt": "2024-01-01T00:00:00Z",
  "lastLogin": "2024-01-01T12:00:00Z",
  "isActive": true
}
```

## Security Features

### ✅ Implemented Security Measures

1. **Password Hashing**: SHA-256 with salt
2. **Unique Salts**: Each user gets a unique random salt
3. **No Plain Text**: Passwords are never stored in plain text
4. **Secure Random**: Uses cryptographically secure random number generation
5. **Input Validation**: Username and password validation
6. **Error Handling**: Proper error handling without exposing sensitive data

### 🔒 Additional Security Recommendations

1. **Password Policy**: Implement minimum password requirements
2. **Rate Limiting**: Limit login attempts
3. **Session Timeout**: Implement automatic logout
4. **HTTPS**: Ensure all communications use HTTPS
5. **Firebase Security Rules**: Configure proper Firestore security rules

## Firebase Security Rules

Add these Firestore security rules to your Firebase console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      // Only authenticated users can read their own data
      allow read: if request.auth != null && 
        (request.auth.uid == userId || 
         resource.data.username == request.auth.token.username);
      
      // Only allow writes from your app (server-side)
      allow write: if false;
    }
  }
}
```

## Troubleshooting

### Common Issues

1. **"User not found"**: Check if the username exists in Firestore
2. **"Invalid password"**: Verify the password is correct
3. **Firebase connection errors**: Check your Firebase configuration
4. **Permission denied**: Verify Firestore security rules

### Debug Mode

To see detailed authentication logs, check the console output when running the app. The system will log:
- User creation success/failure
- Login attempts
- Password verification results

## Production Considerations

1. **Change Default Passwords**: Change all default passwords
2. **Remove Setup Script**: Remove or secure the setup script in production
3. **Admin Access**: Restrict admin screen access
4. **Monitoring**: Set up Firebase monitoring and alerts
5. **Backup**: Regular database backups
6. **Updates**: Keep dependencies updated

## Support

If you encounter any issues:

1. Check the Firebase console for errors
2. Verify your Firebase configuration
3. Check the console logs for detailed error messages
4. Ensure all dependencies are properly installed

---

**Remember**: This system provides a solid foundation for secure authentication. For production use, consider implementing additional security measures like two-factor authentication, biometric login, and advanced session management. 