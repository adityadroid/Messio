import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

/* Creating mock objects for all the firebase related classes
   we'll use these to try and recreate the flow of the functions in actual app
   Properties are overriden in places where they are used
   for example accessToken and idToken are passed on to AutheCredential object
 */

/*
AuthenticationProvider Mocks
 */

class FirebaseAuthMock extends Mock implements FirebaseAuth{}
class GoogleSignInMock extends Mock implements GoogleSignIn{}
class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount{}

class GoogleSignInAuthenticationMock extends Mock implements GoogleSignInAuthentication{
  @override
  String get accessToken => 'mock_access_token';
  @override
  String get idToken => 'mock_id_token';
}

class AuthCredentialMock extends Mock implements AuthCredential{}

class FirebaseUserMock extends Mock implements FirebaseUser{
  @override
  String get displayName => 'John Doe';
  @override
  String get uid => 'uid';
  @override
  String get email => 'johndoe@mail.com';
  @override
  String get photoUrl => 'http://www.adityag.me';
}

/*
StorageProvider Mocks
 */

class FirebaseStorageMock extends Mock implements FirebaseStorage{}
class StorageReferenceMock extends Mock implements StorageReference{
  StorageReferenceMock childReference;
  StorageReferenceMock({this.childReference});
  @override
  StorageReference child(String path) {
    // TODO: implement child
    return childReference;
  }
}
class StorageUploadTaskMock extends Mock implements StorageUploadTask{}
class StorageTaskSnapshotMock extends Mock implements StorageTaskSnapshot{}

/*
UserDataProvider Mocks
 */
class FireStoreMock extends Mock implements Firestore{}
class DocumentReferenceMock extends Mock implements DocumentReference{
  DocumentSnapshotMock documentSnapshotMock;

  DocumentReferenceMock({this.documentSnapshotMock});

  @override
  Future<DocumentSnapshot> get({Source source = Source.serverAndCache}) {
    // TODO: implement get
    return Future<DocumentSnapshotMock>.value(documentSnapshotMock);
  }
  @override
  Stream<DocumentSnapshot> snapshots({bool includeMetadataChanges = false}) {
    if(documentSnapshotMock!=null)
    return Stream.fromFuture(Future<DocumentSnapshotMock>.value(documentSnapshotMock));
    else
      return Stream.empty();
  }
  @override
  Future<void> setData(Map<String,dynamic > data, {bool merge = false}) {
    if(this.documentSnapshotMock==null)
      this.documentSnapshotMock = DocumentSnapshotMock();
    data.forEach((k,v){
      if(!documentSnapshotMock.mockData.containsKey(k))
        documentSnapshotMock.mockData[k]=v;
    });
    return null;
  }

}
class DocumentSnapshotMock extends Mock implements DocumentSnapshot{
  Map mockData = Map<String,dynamic>();

  set data(Map data)  => this.mockData = data;
  @override
  Map<String,dynamic > get data => mockData;
}

class CollectionReferenceMock extends Mock implements CollectionReference{}