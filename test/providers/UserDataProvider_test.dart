import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Paths.dart';
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

     SharedPreferencesMock sharedPreferencesMock = SharedPreferencesMock();
    SharedObjects.prefs = sharedPreferencesMock;

    test('saveDetailsFromGoogleAuth returns a user with the details from FirebaseUser Object passed', () async {
      CollectionReferenceMock collectionReference = CollectionReferenceMock();
      DocumentSnapshotMock documentSnapshot = DocumentSnapshotMock();
      DocumentReferenceMock documentReference = DocumentReferenceMock();

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

    test('saveDetailsFromGoogleAuth if there is not existing image write the image from firebase user', () async {
      CollectionReferenceMock collectionReference = CollectionReferenceMock();
      DocumentReferenceMock documentReference = DocumentReferenceMock();

      when(SharedObjects.prefs.getString(any)).thenReturn('uid');
          when(SharedObjects.prefs.getString(any)).thenReturn('');
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

    test('saveDetailsFromGoogleAuth if there is existing image, do not write the image from firebase user', () async {
      CollectionReferenceMock collectionReference = CollectionReferenceMock();
      DocumentSnapshotMock documentSnapshot = DocumentSnapshotMock(mockData: Map<String,dynamic>.from({'photoUrl':'http://www.google.com'}));       //create a snapshot first to mock existing user
      DocumentReferenceMock documentReference = DocumentReferenceMock();
      documentReference =
          DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      when(SharedObjects.prefs.getString(any)).thenReturn('uid');
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
      CollectionReferenceMock collectionReference = CollectionReferenceMock();
      DocumentReferenceMock documentReference = DocumentReferenceMock();
      when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
      when(sharedPreferencesMock.getString(any)).thenReturn('uid');
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
      CollectionReferenceMock collectionReference = CollectionReferenceMock();
      DocumentSnapshotMock documentSnapshot = DocumentSnapshotMock();
      DocumentReferenceMock documentReference = DocumentReferenceMock();
      // set profile data. Should return profile complete
      when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
      documentReference =
          DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      documentReference.setData({'username': 'johndoe', 'age': 18, 'photoUrl':'http://adityag.me'});
      when(sharedPreferencesMock.getString(any)).thenReturn('uid');
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty, false);
      expect(await userDataProvider.isProfileComplete(), true);

      //clear profile data. Shoudl return false now
      documentReference = DocumentReferenceMock();
      when(fireStore.collection(any)).thenReturn(collectionReference);
      when(collectionReference.document(any)).thenReturn(documentReference);
      expect(await documentReference.snapshots().isEmpty, true);
      expect(await userDataProvider.isProfileComplete(), false);
    });

    test('Add Contacts fails if username already exists',() async{
      CollectionReferenceMock collectionReference = CollectionReferenceMock();
      DocumentSnapshotMock documentSnapshot = DocumentSnapshotMock();
      DocumentReferenceMock documentReference = DocumentReferenceMock();
      String username = 'johndoe'; //arbitrary username
      when(sharedPreferencesMock.getString(any)).thenReturn('uid'); //mock the sharedprefs
      documentSnapshot = DocumentSnapshotMock();  //mock documentsnapshot
      documentReference = DocumentReferenceMock(documentSnapshotMock: documentSnapshot);
      documentReference.setData({
        'uid':'uid',
        'contacts':[username]  // setting the usename in the data already so that duplicate contact exception is thrown
      });
      when(collectionReference.document(any)).thenReturn(documentReference);
      when(fireStore.collection(any)).thenReturn(collectionReference);
      expect(()=>userDataProvider.addContact(username),throwsA(isInstanceOf<ContactAlreadyExistsException>())); // check if the exception is actually thrown
      
    });

    test('mapDocumentToContact mapping returns the correct contact list',() async{
      when(sharedPreferencesMock.getString(Constants.sessionUid)).thenReturn('uid_roger'); //mock the sharedprefs
      DocumentSnapshotMock userSnapshot = DocumentSnapshotMock(); //mock user document
      DocumentSnapshotMock contactSnapshot = DocumentSnapshotMock();  //mock contact document
      DocumentSnapshotMock mappingSnapshot = DocumentSnapshotMock(); //mock uid username mapping

      userSnapshot.mockData = Map<String,dynamic>.from({  //this is the data of the current suer
        'name' : 'Roger',
        'username' : 'roger',
        'uid': 'uid_roger',
        'contacts': ['johndoe'],
        'chats':{'johndoe':'chat1'}
      });
      contactSnapshot.mockData = Map<String,dynamic>.from({  // this is the data of the contact
        'name':'John Doe',
        'photoUrl': 'http://www.adityag.me',
        'uid' : 'uid_john',
        'username':'johndoe'
      });
      when(contactSnapshot.documentID).thenReturn('documentId');

      mappingSnapshot.mockData = Map<String,dynamic>.from({
        'uid': 'uid_john',
      });
      //create references for all the documents we created
      DocumentReferenceMock contactRef = DocumentReferenceMock(documentSnapshotMock: contactSnapshot);
      DocumentReferenceMock userRef = DocumentReferenceMock(documentSnapshotMock: userSnapshot);
      DocumentReferenceMock mappingRef = DocumentReferenceMock(documentSnapshotMock: mappingSnapshot);

      CollectionReferenceMock userCollectionRef = CollectionReferenceMock(); // /users collection
      CollectionReferenceMock mappingCollection = CollectionReferenceMock(); //  /username_uid_map colleciton
      when(userCollectionRef.document('uid_roger')).thenReturn(userRef);   // when document requested is uid_roger then return the user
      when(userCollectionRef.document('uid_john')).thenReturn(contactRef);   //when document requested is uid_john then return the user of john
      when(mappingCollection.document('johndoe')).thenReturn(mappingRef); //when username is john_doe
      when(fireStore.collection(Paths.usersPath)).thenReturn(userCollectionRef);
      when(fireStore.collection(Paths.usernameUidMapPath)).thenReturn(mappingCollection);
      StreamController streamController = StreamController<List<Contact>>();
      StreamSink<List<Contact>> sink = streamController.sink;
      Stream<List<Contact>> stream = streamController.stream;
      stream.listen((List<Contact> list){
        expect(list.length,1); // we should get 1 contact
        expect(list[0].chatId, 'chat1'); //verify all the fields of the contact model
        expect(list[0].username,'johndoe');
        expect(list[0].photoUrl, 'http://www.adityag.me');
        expect(list[0].name, 'John Doe');
        streamController.close();
      });
      userDataProvider.mapDocumentToContact(userCollectionRef, userRef, userSnapshot, sink);
    });

    test('mapDocumentToContact mapping return empty when no contacts ',()async {
      when(sharedPreferencesMock.getString(Constants.sessionUid)).thenReturn('uid_roger'); //mock the sharedprefs
      DocumentSnapshotMock userSnapshot = DocumentSnapshotMock();
      userSnapshot.mockData = Map<String,dynamic>.from({
        'name' : 'Roger',
        'username' : 'roger',
        'uid': 'uid_roger',
        'contacts': []
      });

      DocumentReferenceMock userRef = DocumentReferenceMock(documentSnapshotMock: userSnapshot);
      CollectionReferenceMock userCollection = CollectionReferenceMock();
      when(userCollection.document('uid_roger')).thenReturn(userRef);
      when(fireStore.collection('/users')).thenReturn(userCollection);
      StreamController streamController = StreamController<List<Contact>>();
      StreamSink<List<Contact>> sink = streamController.sink;
      Stream<List<Contact>> stream = streamController.stream;
      stream.listen((List<Contact> list){
        expect(list.length,0);
        streamController.close();
      });
      userDataProvider.mapDocumentToContact(userCollection, userRef, userSnapshot, sink);

    });

    test('Verify updateProfilePicture works properly',() async{
      CollectionReferenceMock usersCollection = CollectionReferenceMock();
      DocumentReferenceMock userReference = DocumentReferenceMock();

      when(SharedObjects.prefs.getString(Constants.sessionUid)).thenReturn('roger_uid');
      when(fireStore.collection(Paths.usersPath)).thenReturn(usersCollection);
      when(usersCollection.document('roger_uid')).thenReturn(userReference);
      userReference.setData({                                   //existing profile picture
        'photoUrl': 'http://firstpic.com/first.jpg'
      });
      expect((await userReference.get()).data['photoUrl'],'http://firstpic.com/first.jpg' ); //check that the old profile pic is there
      userDataProvider.updateProfilePicture('http://adityag.me');   // set a new profile pic
      expect((await userReference.get()).data['photoUrl'],'http://adityag.me' ); //check if userref got updated

    });

    test('Verify getUidByUsername returns the correct uid',() async {
      DocumentReferenceMock userDocument = DocumentReferenceMock();
      userDocument.setData({
        'uid':'roger_uid'
      });
      CollectionReferenceMock usernameMappingCollection = CollectionReferenceMock();
      when(fireStore.collection(Paths.usernameUidMapPath)).thenReturn(usernameMappingCollection);
      when(usernameMappingCollection.document('roger')).thenReturn(userDocument);
      expect(await userDataProvider.getUidByUsername('roger'), 'roger_uid');
    });

    test('Verify getUidByUsername throws exception when there is no mapping',() async {
      CollectionReferenceMock usernameMappingCollection = CollectionReferenceMock();
      DocumentReferenceMock userDoc = DocumentReferenceMock();
      when(fireStore.collection(Paths.usernameUidMapPath)).thenReturn(usernameMappingCollection);
      when(usernameMappingCollection.document('roger')).thenReturn(userDoc);
      expect(()=>userDataProvider.getUidByUsername('roger'),throwsA(isInstanceOf<UsernameMappingUndefinedException>()));
    });

    test('Verify getUser returns the correct user',() async{

      //setup getUidByUsername
      DocumentReferenceMock userDocument = DocumentReferenceMock();
      userDocument.setData({
        'uid':'roger_uid'
      });
      CollectionReferenceMock usernameMappingCollection = CollectionReferenceMock();
      when(fireStore.collection(Paths.usernameUidMapPath)).thenReturn(usernameMappingCollection);
      when(usernameMappingCollection.document('roger')).thenReturn(userDocument);

      //setup getUser
      CollectionReferenceMock usersCollection = CollectionReferenceMock();
      DocumentReferenceMock userRef = DocumentReferenceMock();
      userRef.setData({
        'name' : 'Roger',
        'username' : 'roger',
        'uid': 'uid_roger',
        'photoUrl': 'http://adityag.me',
        'contacts': []
      });
      when(fireStore.collection(Paths.usersPath)).thenReturn(usersCollection);
      when(usersCollection.document('roger_uid')).thenReturn(userRef);
      User user = await userDataProvider.getUser('roger');
      expect(user.name, 'Roger');
      expect(user.username, 'roger');
      expect(user.photoUrl,'http://adityag.me');

    });


    test('Verify getUser throws UserNotFoundException when no user it found in /users collection for that uid',() async{
      //setup getUidByUsername
      DocumentReferenceMock userDocument = DocumentReferenceMock();
      userDocument.setData({
        'uid':'roger_uid'
      });
      CollectionReferenceMock usernameMappingCollection = CollectionReferenceMock();
      when(fireStore.collection(Paths.usernameUidMapPath)).thenReturn(usernameMappingCollection);
      when(usernameMappingCollection.document('roger')).thenReturn(userDocument);
      //setup getUser
      CollectionReferenceMock usersCollection = CollectionReferenceMock();
      DocumentReferenceMock userRef = DocumentReferenceMock(); //we're not setting any data which means that the snapshot will be null/not exists
      when(fireStore.collection(Paths.usersPath)).thenReturn(usersCollection);
      when(usersCollection.document('roger_uid')).thenReturn(userRef);
      expect(()=>userDataProvider.getUser('roger'),throwsA(isInstanceOf<UserNotFoundException>()));
    });
  });
}
