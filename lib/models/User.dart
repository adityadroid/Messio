import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String documentId;
  String name;
  String username;
  int age;
  String photoUrl;

  User({this.documentId, this.name, this.username, this.age, this.photoUrl});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
      documentId: doc.documentID,
      name: data['name'],
      username: data['username'],
      age: data['age'],
      photoUrl: data['photoUrl']
    );
  }
  factory User.fromMap(Map data) {
    return User(
        documentId: data['uid'],
        name: data['name'],
        username: data['username'],
        age: data['age'],
        photoUrl: data['photoUrl']
    );
  }
  @override
  String toString() {
   return '{ documentId: $documentId, name: $name, age: $age, username: $username, photoUrl: $photoUrl }';
  }
}