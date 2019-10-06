import 'dart:async';

import 'package:messio/models/Chat.dart';
import 'package:messio/models/Conversation.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/providers/ChatProvider.dart';
import 'package:messio/providers/db/DBChatProvider.dart';

import 'BaseRepository.dart';


class ChatRepository extends BaseRepository{
  BaseChatProvider chatProvider = ChatProvider();
  DBChatProvider dbChatProvider = DBChatProvider();
  Stream<List<Conversation>> getConversations() => chatProvider.getConversations();
  Map<String, StreamController> streamControllers = Map();
  Stream<List<Chat>> getChats() => chatProvider.getChats();
  //Stream<List<Message>> getMessages(String chatId) => chatProvider.getMessages(chatId);

  Stream<List<Message>> getMessages(String chatId){
    // ignore: close_sinks
    StreamController<List<Message>> messageStreamController = StreamController();
    StreamSink sink = messageStreamController.sink;
    Stream<List<Message>> stream = messageStreamController.stream;
    streamControllers[chatId] = messageStreamController;
    dbChatProvider.getMessages(chatId).then((messages){
      print('received from db $messages');
      messages.forEach((f)=>print('type is ${f.runtimeType}'));
      messageStreamController.sink.add(messages);
    });
    chatProvider.getMessages(chatId).listen((messages){
      print('received from network');
      dbChatProvider.putMessages(chatId, messages);
      sink.add(messages);
    });
    return stream;
  }

  Future<List<Message>> getPreviousMessages(
          String chatId, Message prevMessage) =>
      chatProvider.getPreviousMessages(chatId, prevMessage);

  Future<List<Message>> getAttachments(String chatId, int type) => chatProvider.getAttachments(chatId, type);

  Future<void> sendMessage(String chatId, Message message)=>chatProvider.sendMessage(chatId, message);

  Future<String> getChatIdByUsername(String username) =>
      chatProvider.getChatIdByUsername(username);

  Future<void> createChatIdForContact(User user) =>
      chatProvider.createChatIdForContact(user);

  @override
  void dispose() {
    streamControllers.forEach((k,v)=>v.close());
    chatProvider.dispose();
  }
}
