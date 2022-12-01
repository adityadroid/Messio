import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Conversation.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:messio/utils/document_snapshot_extension.dart';

import 'BaseProviders.dart';

class ChatProvider extends BaseChatProvider {
  final FirebaseFirestore fireStoreDb;
  StreamController<List<Conversation>> conversationStreamController;
  ChatProvider({FirebaseFirestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? FirebaseFirestore.instance
    ..settings = Settings(persistenceEnabled: true);

  @override
  Stream<List<Conversation>> getConversations()  {
    conversationStreamController = StreamController();
    conversationStreamController.sink;
    String username = SharedObjects.prefs.getString(Constants.sessionUsername);
    return fireStoreDb.collection(Paths.chatsPath)
        .where(
        'members', arrayContains: username)  //get all the chats the user is part of
        .orderBy('latestMessage.timeStamp',descending: true)  //order them by timestamp always. latest on top
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Conversation>>.fromHandlers(
        handleData: (QuerySnapshot querySnapshot,
            EventSink<List<Conversation>> sink) =>
            mapQueryToConversation(querySnapshot, sink)));
  }

    void mapQueryToConversation(QuerySnapshot querySnapshot,EventSink<List<Conversation>> sink){
    List<Conversation> conversations = List();
    querySnapshot.docs.forEach((document){
      conversations.add(Conversation.fromFireStore(document));
    });
    sink.add(conversations);
    }


  @override
  Stream<List<Chat>> getChats() {
    String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    return fireStoreDb
        .collection(Paths.usersPath)
        .doc(uId)
        .snapshots()
        .transform(StreamTransformer<DocumentSnapshot, List<Chat>>.fromHandlers(
        handleData: (DocumentSnapshot documentSnapshot,
            EventSink<List<Chat>> sink) =>
            mapDocumentToChat(documentSnapshot, sink)));
  }
  void mapDocumentToChat(DocumentSnapshot documentSnapshot,
      EventSink sink) async {
    List<Chat> chats = List();
    Map data = documentSnapshot.dataAsMap['chats'];
    if (data != null) {
      data.forEach((key, value) => chats.add(Chat(key, value)));
      sink.add(chats);
    }
  }


  @override
  Stream<List<Message>> getMessages(String chatId) {
    DocumentReference chatDocRef =
    fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
    chatDocRef.collection(Paths.messagesPath);
    return messagesCollection
        .orderBy('timeStamp', descending: true)
        .limit(20)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
        handleData:
            (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
            mapDocumentToMessage(querySnapshot, sink)));
  }

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    List<Message> messages = List();
    for (DocumentSnapshot document in querySnapshot.docs) {
      messages.add(Message.fromFireStore(document));
    }
    sink.add(messages);
  }

  /*
  Here prevMessage contains the documentID of the last messages from the top on the chat screen.
   */
  @override
  Future<List<Message>> getPreviousMessages(String chatId,
      Message prevMessage) async {
    DocumentReference chatDocRef =
    fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
    chatDocRef.collection(Paths.messagesPath);
    DocumentSnapshot prevDocument;
    prevDocument = await messagesCollection
        .doc(prevMessage.documentId)
        .get(); // gets a reference to the last message in the existing list
    final querySnapshot = await messagesCollection
        .startAfterDocument(
        prevDocument) // Start reading documents after the specified document
        .orderBy('timeStamp', descending: true) // order them by timestamp
        .limit(20) // limit the read to 20 items
        .get();
    List<Message> messageList = List();
    querySnapshot.docs
        .forEach((doc) => messageList.add(Message.fromFireStore(doc)));
    return messageList;
  }

  @override
  Future<List<Message>> getAttachments(String chatId, int type) async {
    DocumentReference chatDocRef = fireStoreDb.collection(Paths.chatsPath).doc(chatId); //get reference to the chat documents
    CollectionReference messagesCollection =
    chatDocRef.collection(Paths.messagesPath);   //get reference to all teh messages in the chat
    final querySnapshot = await messagesCollection
        .where('type', isEqualTo: type)  // filter the messages based on type
        .orderBy('timeStamp', descending: true) // order them by timestamp
        .get();
    List<Message> messageList = List();
    querySnapshot.docs
        .forEach((doc) => messageList.add(Message.fromFireStore(doc)));
    return messageList;
  }


  @override
  Future<void> sendMessage(String chatId, Message message) async {
    DocumentReference chatDocRef =
    fireStoreDb.collection(Paths.chatsPath).doc(chatId);
    CollectionReference messagesCollection =
    chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
    await chatDocRef.update({'latestMessage': message.toMap()});
  }

  @override
  Future<String> getChatIdByUsername(String username) async {
    String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    String selfUsername =
    SharedObjects.prefs.getString(Constants.sessionUsername);
    DocumentReference userRef =
    fireStoreDb.collection(Paths.usersPath).doc(uId);
    DocumentSnapshot documentSnapshot = await userRef.get();
    String chatId = documentSnapshot.dataAsMap['chats'][username];
    if (chatId == null) {
      chatId = await createChatIdForUsers(selfUsername, username);
      userRef.update({
        'chats': {username: chatId}
      });
    }
    return chatId;
  }

  @override
  Future<void> createChatIdForContact(MessioUser user) async {
    String contactUid = user.documentId;
    String contactUsername = user.username;
    String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    String selfUsername =
    SharedObjects.prefs.getString(Constants.sessionUsername);
    CollectionReference usersCollection =
    fireStoreDb.collection(Paths.usersPath);
    DocumentReference userRef = usersCollection.doc(uId);
    DocumentReference contactRef = usersCollection.doc(contactUid);
    DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.dataAsMap['chats'] == null ||
        userSnapshot.dataAsMap['chats'][contactUsername] == null) {
      String chatId = await createChatIdForUsers(selfUsername, contactUsername);
      await userRef.set({
        'chats': {contactUsername: chatId}
      },SetOptions( merge: true));
      await contactRef.set({
        'chats': {selfUsername: chatId}
      }, SetOptions(merge: true));
    }
  }

  Future<String> createChatIdForUsers(String selfUsername,
      String contactUsername) async {
    CollectionReference chatCollection = fireStoreDb.collection(Paths.chatsPath);
    CollectionReference  userUidMapCollection = fireStoreDb.collection(Paths.usernameUidMapPath);
    CollectionReference usersCollection = fireStoreDb.collection(Paths.usersPath);
     String selfUid  =(await  userUidMapCollection.doc(selfUsername).get()).dataAsMap['uid'];
    String contactUid  = (await userUidMapCollection.doc(contactUsername).get()).dataAsMap['uid'];
    print('self $selfUid , contact $contactUid');
    DocumentSnapshot selfDocRef = await usersCollection.doc(selfUid).get();
    DocumentSnapshot contactDocRef = await usersCollection.doc(contactUid).get();
    DocumentReference documentReference = await chatCollection.add({
      'members': [selfUsername, contactUsername],
      'membersData': [selfDocRef.data, contactDocRef.data]
    });
    return documentReference.id;
  }

  @override
  void dispose() {
    if(conversationStreamController!=null)
        conversationStreamController.close();
  }
}
