import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/providers/UserDataProvider.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(
          String uid, String profileImageUrl, int age, String username) =>
      userDataProvider.saveProfileDetails(uid, profileImageUrl, age, username);

  Future<bool> isProfileComplete(String uid) =>
      userDataProvider.isProfileComplete(uid);
}
