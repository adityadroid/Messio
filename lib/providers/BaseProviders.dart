import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/models/User.dart';

abstract class BaseAuthenticationProvider{
  Future<FirebaseUser> signInWithGoogle();
  Future<void> signOutUser();
  Future<FirebaseUser> getCurrentUser();
  Future<bool> isLoggedIn();
}

abstract class BaseUserDataProvider{
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);
  Future<User> saveProfileDetails(String profileImageUrl, int age, String username);
  Future<bool> isProfileComplete();
  Stream<List<Contact>> getContacts();
  Future<void> addContact(String username);
  Future<User> getUser(String username);
  Future<String> getUidByUsername(String username);
}

abstract class BaseStorageProvider{
  Future<String> uploadImage(File file, String path);
}