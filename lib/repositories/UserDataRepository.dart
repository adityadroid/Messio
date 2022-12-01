import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/providers/UserDataProvider.dart';
import 'package:messio/repositories/BaseRepository.dart';

class UserDataRepository extends BaseRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<MessioUser> saveDetailsFromGoogleAuth(User user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<MessioUser> saveProfileDetails(
          String uid, String profileImageUrl, int age, String username) =>
      userDataProvider.saveProfileDetails(profileImageUrl, age, username);

  Future<bool> isProfileComplete() => userDataProvider.isProfileComplete();

  Stream<List<Contact>> getContacts() => userDataProvider.getContacts();

  Future<void> addContact(String username) =>
      userDataProvider.addContact(username);

  Future<MessioUser> getUser(String username) => userDataProvider.getUser(username);
  Future<void> updateProfilePicture(String profilePictureUrl)=> userDataProvider.updateProfilePicture(profilePictureUrl);

  @override
  void dispose() {
    userDataProvider.dispose();
  }

}
