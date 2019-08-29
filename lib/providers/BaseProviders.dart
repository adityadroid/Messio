import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/models/User.dart';

abstract class BaseAuthenticationProvider{
  Future<FirebaseUser> signInWithGoogle();
  Future<void> signOutUser();
  Future<FirebaseUser> getCurrentUser();
  Future<bool> isLoggedIn();
}

abstract class BaseUserDataProvider{
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);
  Future<User> saveProfileDetails(String uid, String profileImageUrl, int age, String username);
  Future<bool> isProfileComplete(String uid);
}

abstract class BaseStorageProvider{
  Future<String> uploadImage(File file, String path);
}