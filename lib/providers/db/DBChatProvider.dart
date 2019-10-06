
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Conversation.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/db/Converters.dart';
import 'package:sembast/sembast.dart';

import 'Database.dart';

class DBChatProvider {
  static const String CHATS_STORE = 'chats';
  final chatsStore = StoreRef<String,List<dynamic>>(CHATS_STORE);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  @override
  Future<void> createChatIdForContact(User user) {
    // TODO: implement createChatIdForContact
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<List<Message>> getAttachments(String chatId, int type) {
    // TODO: implement getAttachments
    return null;
  }

  @override
  Future<String> getChatIdByUsername(String username) {
    // TODO: implement getChatIdByUsername
    return null;
  }

  @override
  Stream<List<Chat>> getChats() {
    // TODO: implement getChats
    return null;
  }

  @override
  Stream<List<Conversation>> getConversations() {
    // TODO: implement getConversations
    return null;
  }

  Future<List<Message>> getMessages(String chatId) async {
    final result = await chatsStore.record(chatId).get(await _db);
    List<Message> messages = messagesFromListOfMap(result);
    return messages;
  }
  void putMessages(String chatId, List<Message> messages) async{
    await chatsStore.record(chatId).add(await _db,toListOfMap(messages));
  }

  @override
  Future<List<Message>> getPreviousMessages(String chatId, Message prevMessage) {
    // TODO: implement getPreviousMessages
    return null;
  }

  @override
  Future<void> sendMessage(String chatId, Message message) {
    // TODO: implement sendMessage
    return null;
  }


}