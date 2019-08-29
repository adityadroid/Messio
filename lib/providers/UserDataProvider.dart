import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';

class UserDataProvider extends BaseUserDataProvider {
  final fireStoreDb = Firestore.instance;

  @override
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    DocumentReference ref = fireStoreDb
        .collection(Paths.usersPath)
        .document(user.uid); //reference of the user's document node in database/users. This node is created using uid
    final bool userExists = await ref.snapshots().isEmpty; // check if user exists or not
    var data = {
      //add details received from google auth
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
    };
    if (!userExists) { // if user entry exists then we would not want to override the photo url with the one received from googel auth
      data['photoUrl'] = user.photoUrl;
    }
    ref.setData(data, merge: true); // set the data
    final DocumentSnapshot currentDocument = await ref.get(); // get updated data reference
    return User.fromFirestore(currentDocument); // create a user object and return
  }

  @override
  Future<User> saveProfileDetails(
      String uid, String profileImageUrl, int age, String username) async {
    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(uid); //reference of the user's document node in database/users. This node is created using uid
    var data = {
      'photoUrl': profileImageUrl,
      'age': age,
      'username': username,
    };
    ref.setData(data, merge: true); // set the photourl, age and username
    final DocumentSnapshot currentDocument = await ref.get(); // get updated data back from firestore
    return User.fromFirestore(currentDocument); // create a user object and return it
  }

  @override
  Future<bool> isProfileComplete(String uid) async {
    DocumentReference ref =
        fireStoreDb.collection(Paths.usersPath).document(uid);  // get reference to the user/ uid node
    final DocumentSnapshot currentDocument = await ref.get();
    return (currentDocument.exists&&
        currentDocument.data.containsKey('username') &&
            currentDocument.data.containsKey('age')); // check if it exists, if yes then check if username and age field are there or not. If not then profile incomplete else complete
  }
}
