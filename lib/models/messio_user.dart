import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/utils/document_snapshot_extension.dart';

class MessioUser{
  String documentId;
  String name;
  String username;
  int age;
  String photoUrl;

  MessioUser({this.documentId, this.name, this.username, this.age, this.photoUrl});

  factory MessioUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.dataAsMap;
    return MessioUser(
      documentId: doc.id,
      name: data['name'],
      username: data['username'],
      age: data['age'],
      photoUrl: data['photoUrl']
    );
  }
  factory MessioUser.fromMap(Map data) {
    return MessioUser(
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