import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Conversation.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/ChatProvider.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:mockito/mockito.dart';

import '../mock/DataMock.dart';
import '../mock/FirebaseMock.dart';
import '../mock/SharedObjectsMock.dart';

void main() {
  //Mock the provider and sharedpreferences
  FireStoreMock fireStore = FireStoreMock();
  ChatProvider chatProvider = ChatProvider(fireStoreDb: fireStore);
  SharedPreferencesMock sharedPreferencesMock = SharedPreferencesMock();
  SharedObjects.prefs = sharedPreferencesMock;


  test('Verify that mapQueryToConversation works properly', () async {

    //mapQueryToConversation returns the list of conversations on the homescreen for the logged in user
    when(sharedPreferencesMock.getString(Constants.sessionUsername))
        .thenReturn("adityagurjar");  //mock the session
    QuerySnapshotMock querySnapshot = QuerySnapshotMock(); //mock two conversations and add them to a QuerySnapshot mock object
    DocumentSnapshotMock ds1 = DocumentSnapshotMock();
    DocumentSnapshotMock ds2 = DocumentSnapshotMock();
    ds1.data = mockConversations[0];
    ds2.data = mockConversations[1];
    when(ds1.documentID).thenReturn('chatId1');
    when(ds2.documentID).thenReturn('chatId2');
    when(querySnapshot.documents).thenReturn([ds1, ds2]);

    StreamController streamController = StreamController<List<Conversation>>();
    StreamSink<List<Conversation>> sink = streamController.sink;
    Stream<List<Conversation>> stream = streamController.stream;
    stream.listen((List<Conversation> list) {
      for (int i = 0; i < list.length; i++) {
        expect(verifyConversationFields(list[i], mockConversations[i]), true); // check that the resultant mappings are done correctly
      }
      streamController.close();
    });
    chatProvider.mapQueryToConversation(querySnapshot, sink);  //pass the mocked QuerySnapshot to the mapping function along with the sink
  });

  test('Verify that mapDocumentToChat works properly', () async {
    // mapDocumentToChat returns all the chats for the conversation slide. This is retrived from users/user_uid/chats map
    DocumentSnapshotMock documentSnapshot = DocumentSnapshotMock();
    documentSnapshot.data = userDataMock; // mock the user data first
    StreamController streamController = StreamController<List<Chat>>();
    StreamSink<List<Chat>> sink = streamController.sink;
    Stream<List<Chat>> stream = streamController.stream;
    stream.listen((list) {
      for (int i = 0; i < list.length; i++) {
        expect(verifyChatFields(list[i], userDataMock), true); //verify if the mapping is working properly
      }
      streamController.close();
    });
    chatProvider.mapDocumentToChat(documentSnapshot, sink); //pass the user DocumentSnapshot to the mapping function
  });

  test('Verify that mapDocumentToMessage works properly', () async {

    // mapDocumentToMessage maps messages from current active chat.
    QuerySnapshotMock querySnapshot = QuerySnapshotMock();
    when(querySnapshot.documents).thenReturn(messageDataMock
        .map((data) => DocumentSnapshotMock(mockData: data))   // create mock DocumentSnapshots for messages
        .toList());
    StreamController streamController = StreamController<List<Message>>();
    StreamSink<List<Message>> sink = streamController.sink;
    Stream<List<Message>> stream = streamController.stream;
    stream.listen((data) {
      for (int i = 0; i < data.length; i++) {
        expect(verifyMessages(data[i], messageDataMock[i]), true);  //Verify if the mapped messages are correct
      }
      streamController.close();
    });
    chatProvider.mapDocumentToMessage(querySnapshot, sink);  //Call the mapping function
  });

  test('Verify that getPreviousMessages works properly', () async {

    // getPreviousMessages gets the last 20 messages from the document supplied.
    CollectionReferenceMock chatsCollection = CollectionReferenceMock(); //Mock teh chat Collection, Chat DocumentReference and the messages collection
    DocumentReferenceMock chatDocument = DocumentReferenceMock();
    CollectionReferenceMock messagesCollection = CollectionReferenceMock();
    QuerySnapshotMock querySnapshot = QuerySnapshotMock();
    DocumentReferenceMock prevMessageDocument = DocumentReferenceMock();  //Mock the previous last message from chat screen.
    when(fireStore.collection(Paths.chatsPath)).thenReturn(chatsCollection);  //Setup the mocking flow
    when(chatsCollection.document('chatid1')).thenReturn(chatDocument);
    when(chatDocument.collection(Paths.messagesPath))
        .thenReturn(messagesCollection);
    when(messagesCollection.document('doc1')).thenReturn(prevMessageDocument);
    QueryMock q1 = QueryMock();  //mock Query objects. We're doing this to make sure that all the three parts of query run. if one of them is pulled out or modified the test will fail
    QueryMock q2 = QueryMock();
    QueryMock q3 = QueryMock();
    when(messagesCollection
            .startAfterDocument(prevMessageDocument.documentSnapshotMock))
        .thenReturn(q1);
    when(q1.orderBy(any, descending: true)).thenReturn(q2);
    when(q2.limit(any)).thenReturn(q3);
    when(q3.getDocuments()).thenAnswer((_) => Future.value(querySnapshot));

    when(querySnapshot.documents).thenReturn(messageDataMock
        .map((data) => DocumentSnapshotMock(mockData: data))
        .toList());
    final messages = await chatProvider.getPreviousMessages(
        'chatid1', TextMessage('', 123123, '', '')..documentId = 'doc1');
    for (int i = 0; i < messages.length; i++) {
      expect(verifyMessages(messages[i], messageDataMock[i]), true);
    }
  });

  test('Verify getAttachments works properly', () async {
    // getAttachments get all the attachments for a chatid
    CollectionReferenceMock chatsCollection = CollectionReferenceMock(); //mock the required collection and document references
    DocumentReferenceMock chatDocRef = DocumentReferenceMock();
    CollectionReferenceMock messagesCollection = CollectionReferenceMock();

    when(fireStore.collection(Paths.chatsPath)).thenReturn(chatsCollection); // mock the flow
    when(chatsCollection.document('chatid1')).thenReturn(chatDocRef);
    when(chatDocRef.collection(Paths.messagesPath))
        .thenReturn(messagesCollection);
    QuerySnapshotMock querySnapshot = QuerySnapshotMock();

    QueryMock query = QueryMock();  //mock the intermediate query object generated. This will cause the test to fail if the type equality condition is removed
    when(messagesCollection.where("type", isEqualTo: 1)).thenReturn(query);
    when(query.orderBy('timeStamp', descending: true)).thenReturn(query);
    when(query.getDocuments()).thenAnswer((_) => Future.value(querySnapshot));
    when(querySnapshot.documents).thenReturn(messageDataMock  //mock the message DocumentSnapshots
        .where((mapItem) => mapItem['type'] == 1)
        .map((data) => DocumentSnapshotMock(mockData: data))
        .toList());
   final attachments =  await chatProvider.getAttachments('chatid1', 1);
   attachments.forEach((message)=>expect((message is ImageMessage), true));
  });

  test('Verify sendMessage works properly',() async {

    CollectionReferenceMock chatsCollection = CollectionReferenceMock(); //Mock the required collection and documents
    DocumentReferenceMock chatDocRef = DocumentReferenceMock();
    CollectionReferenceMock messagesCollection = CollectionReferenceMock();

    when(fireStore.collection(Paths.chatsPath)).thenReturn(chatsCollection);  // mock the flow
    when(chatsCollection.document('chatid1')).thenReturn(chatDocRef);
    when(chatDocRef.collection(Paths.messagesPath))
        .thenReturn(messagesCollection);
    when(messagesCollection.add(any)).thenAnswer((_)=>Future.value(DocumentReferenceMock()));
    chatProvider.sendMessage('chatid1', TextMessage('Hi', 120193210, 'Aditya Gurjar', 'adityagurjar')); // send the message
    final updatedDoc = await chatDocRef.get();

    expect(updatedDoc.data['latestMessage']['text'],'Hi'); //check of the sent message is passed over to the document properly
    expect(updatedDoc.data['latestMessage']['timeStamp'],120193210);
    expect(updatedDoc.data['latestMessage']['senderName'],'Aditya Gurjar');
    expect(updatedDoc.data['latestMessage']['senderUsername'],'adityagurjar');
  });


  test('Verify getChatIdByUsername works properly',() async {

  CollectionReferenceMock usersCollection = CollectionReferenceMock(); // mock the collections and documents
  DocumentReferenceMock userRef = DocumentReferenceMock();
  userRef.setData({
    'chats': {
      'steve': 'chatid1',
      'aditya': 'chatid2'
    }
  });
  when(SharedObjects.prefs.getString(Constants.sessionUid)).thenReturn('roger_uid'); //mock the flow of the function
  when(SharedObjects.prefs.getString(Constants.sessionUsername)).thenReturn('roger_username');
  when(fireStore.collection(Paths.usersPath)).thenReturn(usersCollection);
  when(usersCollection.document('roger_uid')).thenReturn(userRef);
  expect(await chatProvider.getChatIdByUsername('steve'),'chatid1'); //get the chatids for both of the users
  expect(await chatProvider.getChatIdByUsername('aditya'), 'chatid2');
  });


  test('Verify createChatIdForUsers creates a new chatId when it does not exists',() async {
    //this method takes two usernames and creates  chatid for them
   CollectionReferenceMock chatCollection = CollectionReferenceMock(); //create the collections
   CollectionReferenceMock userUidMapCollection = CollectionReferenceMock();
   CollectionReferenceMock usersCollection = CollectionReferenceMock();
   DocumentReferenceMock user1UidMapDoc = DocumentReferenceMock()..setData({'uid':'user1_uid'}); //create the username-uid mapping for both the users
   DocumentReferenceMock user2UidMapDoc = DocumentReferenceMock()..setData({'uid':'user2_uid'});
   final user1Data = {
     'name':'User 1',
     'username': 'user1',
     'photoUrl': 'http://www.user1.com/img.jpg',
     'age':19,
     'email':'user1@gmail.com',
     'uid': 'user1_uid',
   };
   final user2Data = {
     'name':'User 2',
     'username': 'user2',
     'photoUrl': 'http://www.user2.com/img.jpg',
     'age':19,
     'email':'user2@gmail.com',
     'uid': 'user2_uid',
   };
   DocumentReferenceMock user1Doc = DocumentReferenceMock()..setData(user1Data);  //create the user docs fro both of them
   DocumentReferenceMock user2Doc = DocumentReferenceMock()..setData(user2Data);
   when(fireStore.collection(Paths.chatsPath)).thenReturn(chatCollection); // Mock the function flow
   when(fireStore.collection(Paths.usernameUidMapPath)).thenReturn(userUidMapCollection);
   when(fireStore.collection(Paths.usersPath)).thenReturn(usersCollection);
   when(userUidMapCollection.document('user1')).thenReturn(user1UidMapDoc);
   when(userUidMapCollection.document('user2')).thenReturn(user2UidMapDoc);

   when(usersCollection.document('user1_uid')).thenReturn(user1Doc);
   when(usersCollection.document('user2_uid')).thenReturn(user2Doc);
   DocumentReferenceMock chatDocumentReference = DocumentReferenceMock();
   when(chatDocumentReference.documentID).thenReturn('user1_user2_chat_id');
   when(chatCollection.add(any)).thenAnswer((_)=>Future.value(chatDocumentReference));
   String chatId = await chatProvider.createChatIdForUsers('user1', 'user2');
   expect(chatId,'user1_user2_chat_id');
   verify(chatCollection.add(any)); //verify that chatCollection.add is called
   verify(chatDocumentReference.documentID); //verify that the chat id is coming by a call on the chatdocumentreference.
  });

  test('Verify createChatIdForContact creates the chatId and inserts it in both users documents',() async {
      //Takes a User as argument and creates the chatid for it and the current logged in user
      CollectionReferenceMock usersCollection =  CollectionReferenceMock(); //mock the user and the collecitons
      User user = User(documentId: 'uid_steve',name:'Steve',username:'username_steve',photoUrl: 'http:/www.steve.com/img.jpg');
      when(SharedObjects.prefs.getString(Constants.sessionUsername)).thenReturn('username_roger'); //mock the session
      when(SharedObjects.prefs.getString(Constants.sessionUid)).thenReturn('uid_roger');
      when(fireStore.collection(Paths.usersPath)).thenReturn(usersCollection);
      DocumentReferenceMock steveUserDoc = DocumentReferenceMock()..setData({}); //create user docs for both the users
      DocumentReferenceMock rogerUserDoc = DocumentReferenceMock()..setData({});
      when(usersCollection.document('uid_steve')).thenReturn(steveUserDoc);
      when(usersCollection.document('uid_roger')).thenReturn(rogerUserDoc);

      // Mock createChatIdForUsers method similar to what we did in the last test
      CollectionReferenceMock chatCollection = CollectionReferenceMock();
      CollectionReferenceMock userUidMapCollection = CollectionReferenceMock();
      when(fireStore.collection(Paths.chatsPath)).thenReturn(chatCollection);
      when(fireStore.collection(Paths.usernameUidMapPath)).thenReturn(userUidMapCollection);

      DocumentReferenceMock steveUidMapDoc = DocumentReferenceMock()..setData({'uid':'uid_steve'});
      DocumentReferenceMock rogerUidMapDoc = DocumentReferenceMock()..setData({'uid':'uid_roger'});

      when(userUidMapCollection.document('username_steve')).thenReturn(steveUidMapDoc);
      when(userUidMapCollection.document('username_roger')).thenReturn(rogerUidMapDoc);

      DocumentReferenceMock chatDocumentReference = DocumentReferenceMock();
      when(chatDocumentReference.documentID).thenReturn('steve_roger_chat_id');
      when(chatCollection.add(any)).thenAnswer((_)=>Future.value(chatDocumentReference));

      await chatProvider.createChatIdForContact(user);
      expect(rogerUserDoc.documentSnapshotMock.data['chats']['username_steve'],'steve_roger_chat_id');
      expect(steveUserDoc.documentSnapshotMock.data['chats']['username_roger'],'steve_roger_chat_id');

  });

}


//verification methods
bool verifyMessages(Message message, Map<String, dynamic> mockMessage) {
  return message.senderName == mockMessage['senderName'] &&
      message.senderUsername == mockMessage['senderUsername'] &&
      message.timeStamp == mockMessage['timeStamp'] &&
      getType(message) == mockMessage['type'];
}

int getType(Message message) {
  if (message is TextMessage)
    return 0;
  else if (message is ImageMessage)
    return 1;
  else if (message is VideoMessage)
    return 2;
  else if (message is FileMessage) return 3;
  return 0;
}

bool verifyChatFields(Chat item, Map<String, dynamic> userData) {
  return userData['chats'].containsKey(item.username) &&
      userData['chats'].containsValue(item.chatId);
}

bool verifyConversationFields(
    Conversation item, Map<String, dynamic> mockData) {
  return item.latestMessage.timeStamp ==
          mockData['latestMessage']['timeStamp'] &&
      item.latestMessage.senderUsername ==
          mockData['latestMessage']['senderUsername'] &&
      item.latestMessage.senderName ==
          mockData['latestMessage']['senderName'] &&
      mockData['members'].contains(item.user.username);
}
