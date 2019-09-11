import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String username;
  String name;
  String documentId;

  Contact(this.documentId, this.username, this.name);

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Contact(doc.documentID, data['username'], data['name']);
  }

  @override
  String toString() {
    return '{ documentId: $documentId, name: $name, username: $username}';
  }

  String getFirstName() => name.split(' ')[0];

  String getLastName(){
    List names = name.split(' ');
    return names.length>1?names[1]:'';
  }
}
