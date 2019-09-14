import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/UserDataProvider.dart';
import 'package:messio/utils/Exceptions.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:mockito/mockito.dart';

import '../mock/FirebaseMock.dart';
import '../mock/SharedObjectsMock.dart';

void main() {

  group('UserDataProvider', () {
    FireStoreMock fireStore = FireStoreMock();
    UserDataProvider userDataProvider =
        UserDataProvider(fireStoreDb: fireStore);

    CollectionReferenceMock collectionReference = CollectionReferenceMock();
    DocumentSnapshotMock documentSnapshot = DocumentSnapshotMock();
    DocumentReferenceMock documentReference = DocumentReferenceMock();
    SharedPreferencesMock sharedPreferencesMock = SharedPreferencesMock();
    SharedObjects.prefs = sharedPreferencesMock;

    test(
        'saveDetailsFromGoogleAuth returns a user with the details from FirebaseUser Object passed',
        () async {
          when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
          when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty,
          true); //no data is saved for this user.
      User user =
          await userDataProvider.saveDetailsFromGoogleAuth(FirebaseUserMock());
      expect(await documentReference.snapshots().isEmpty,
          false); // data is saved. snapshots has one snapshot
      documentSnapshot = await documentReference.get();
      expect(documentSnapshot.data['uid'],
          'uid'); //checking if the data from the passed FirebaseUser object is returned in User
      expect(user.name, 'John Doe');
      expect(user.photoUrl, 'http://www.adityag.me');
    });

    test(
        'saveDetailsFromGoogleAuth if there is not existing image write the image from firebase user',
        () async {
          when(SharedObjects.prefs.get(any)).thenReturn('uid');
          when(SharedObjects.prefs.get(any)).thenReturn('');
          when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
          documentReference = DocumentReferenceMock();
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty,
          true); //no data is saved, fresh user
      User user =
          await userDataProvider.saveDetailsFromGoogleAuth(FirebaseUserMock());
      expect(user.name, 'John Doe');
      expect(user.photoUrl,
          'http://www.adityag.me'); //image from FirebaseUser object is written
    });

    test(
        'saveDetailsFromGoogleAuth if there is existing image, do not write the image from firebase user',
        () async {

      documentSnapshot.data['photoUrl'] =
          'http://www.google.com'; //create a snapshot first to mock existing user
      documentReference =
          DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      when(SharedObjects.prefs.get(any)).thenReturn('uid');
      when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty,
          false); // snapshots are not empty because existing user
      User user =
          await userDataProvider.saveDetailsFromGoogleAuth(FirebaseUserMock());
      expect(await documentReference.snapshots().isEmpty, false);
      expect(user.name, 'John Doe');
      expect(user.photoUrl,
          'http://www.google.com'); // for existing user the image is not overwritten.
    });

    test('saveProfileDetails saves the details', () async {
      when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
      when(sharedPreferencesMock.get(any)).thenReturn('uid');
      documentReference = DocumentReferenceMock(); //create a user
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty, true);
      User user = await userDataProvider.saveProfileDetails('http://www.github.com', 18, 'johndoe');
      expect(await documentReference.snapshots().isEmpty, false);
      expect(user.age, 18); // checking if passed data is saved
      expect(user.username, 'johndoe');
      expect(user.photoUrl, 'http://www.github.com');
    });

    test('isProfileComplete works properly', () async {
      // set profile data. Should return profile complete
      when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
      documentReference =
          DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      documentReference.setData({'username': 'johndoe', 'age': 18});
      when(sharedPreferencesMock.get(any)).thenReturn('uid');
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      when(documentSnapshot.exists).thenReturn(true);
      expect(await documentReference.snapshots().isEmpty, false);
      expect(await userDataProvider.isProfileComplete(), true);

      //clear profile data. Shoudl return false now
      documentReference = DocumentReferenceMock();
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      when(documentSnapshot.exists).thenReturn(true);
      expect(await documentReference.snapshots().isEmpty, true);
      expect(await userDataProvider.isProfileComplete(), false);
    });

    test('Add Contacts fails if username already exists',() async{
      String username = 'johndoe'; //arbitrary username
      when(sharedPreferencesMock.get(any)).thenReturn('uid'); //mock the sharedprefs
      documentSnapshot = DocumentSnapshotMock();  //mock documentsnapshot
      when(documentSnapshot.exists).thenReturn(true); // this is done to pass the getUidByUsername method
      documentReference = DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      documentReference.setData({
        'uid':'uid',
        'contacts':[username]  // setting the usename in the data already so that duplicate contact exception is thrown
      });
      when(collectionReference.document(any)).thenReturn(documentReference);
      when(fireStore.collection(any)).thenReturn(collectionReference);
      expect(()=>userDataProvider.addContact(username),throwsA(isInstanceOf<ContactAlreadyExistsException>())); // check if the exception is actually thrown
      
    });

    test('getContacts returns a empty list when there is no contact',() async{
      when(sharedPreferencesMock.get(any)).thenReturn('uid'); //mock the sharedprefs
      DocumentSnapshotMock contactSnapshot = DocumentSnapshotMock();  //mock documentsnapshot
      DocumentSnapshotMock userSnapshot = DocumentSnapshotMock();
      DocumentSnapshotMock mappingSnapshot = DocumentSnapshotMock();
      when(contactSnapshot.exists).thenReturn(true);
      when(userSnapshot.exists).thenReturn(true);
      when(mappingSnapshot.exists).thenReturn(true);

      contactSnapshot.mockData = Map<String,dynamic>.from({
        'name':'John Doe',
        'uid' : 'john',
        'username':'johndoe'
      });
      when(contactSnapshot.documentID).thenReturn('documentId');
      userSnapshot.mockData = Map<String,dynamic>.from({
        'name' : 'Roger',
        'username' : 'roger',
        'uid': 'uid',
        'contacts': ['johndoe']
      });
      mappingSnapshot.mockData = Map<String,dynamic>.from({
        'uid': 'john'
      });
      DocumentReferenceMock contactRef = DocumentReferenceMock(documentSnapshotMock: contactSnapshot);
      DocumentReferenceMock userRef = DocumentReferenceMock(documentSnapshotMock: userSnapshot);
      DocumentReferenceMock mappingRef = DocumentReferenceMock(documentSnapshotMock: mappingSnapshot);
      CollectionReferenceMock userCollection = CollectionReferenceMock();
      CollectionReferenceMock mappingCollection = CollectionReferenceMock();
      when(userCollection.document('uid')).thenReturn(userRef);
      when(userCollection.document('john')).thenReturn(contactRef);
      when(mappingCollection.document('johndoe')).thenReturn(mappingRef);
      when(fireStore.collection('/users')).thenReturn(userCollection);
      when(fireStore.collection('/username_uid_map')).thenReturn(mappingCollection);
      StreamController streamController = StreamController<List<Contact>>();
      StreamSink<List<Contact>> sink = streamController.sink;
      Stream<List<Contact>> stream = streamController.stream;
      stream.listen((List<Contact> list){
        expect(list.length,1);
      });
      userDataProvider.mapDocumentToContact(userCollection, userRef, documentSnapshot, sink);
    });

    test('mapDocumentToContact mapping works properly',()async {
      when(sharedPreferencesMock.get(any)).thenReturn('uid'); //mock the sharedprefs
      DocumentSnapshotMock contactSnapshot = DocumentSnapshotMock();  //mock documentsnapshot
      DocumentSnapshotMock userSnapshot = DocumentSnapshotMock();
      DocumentSnapshotMock mappingSnapshot = DocumentSnapshotMock();
      when(contactSnapshot.exists).thenReturn(true);
      when(userSnapshot.exists).thenReturn(true);
      when(mappingSnapshot.exists).thenReturn(true);

      contactSnapshot.mockData = Map<String,dynamic>.from({
        'name':'John Doe',
        'uid' : 'john',
        'username':'johndoe'
      });
      when(contactSnapshot.documentID).thenReturn('documentId');
      userSnapshot.mockData = Map<String,dynamic>.from({
        'name' : 'Roger',
        'username' : 'roger',
        'uid': 'uid',
        'contacts': ['johndoe']
      });
      mappingSnapshot.mockData = Map<String,dynamic>.from({
        'uid': 'john'
      });
      DocumentReferenceMock contactRef = DocumentReferenceMock(documentSnapshotMock: contactSnapshot);
      DocumentReferenceMock userRef = DocumentReferenceMock(documentSnapshotMock: userSnapshot);
      DocumentReferenceMock mappingRef = DocumentReferenceMock(documentSnapshotMock: mappingSnapshot);
      CollectionReferenceMock userCollection = CollectionReferenceMock();
      CollectionReferenceMock mappingCollection = CollectionReferenceMock();
      when(userCollection.document('uid')).thenReturn(userRef);
      when(userCollection.document('john')).thenReturn(contactRef);
      when(mappingCollection.document('johndoe')).thenReturn(mappingRef);
      when(fireStore.collection('/users')).thenReturn(userCollection);
      when(fireStore.collection('/username_uid_map')).thenReturn(mappingCollection);
      StreamController streamController = StreamController<List<Contact>>();
      StreamSink<List<Contact>> sink = streamController.sink;
      Stream<List<Contact>> stream = streamController.stream;
      stream.listen((List<Contact> list){
        expect(list.length,1);
      });
      userDataProvider.mapDocumentToContact(userCollection, userRef, documentSnapshot, sink);

    });
  });
}
