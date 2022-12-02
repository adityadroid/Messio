import 'dart:async';

import 'package:messio/models/chat.dart';
import 'package:messio/models/conversation.dart';
import 'package:messio/models/message.dart';
import 'package:messio/models/messio_user.dart';
import 'package:messio/providers/base_providers.dart';
import 'package:messio/providers/chat_provider.dart';

import 'base_repository.dart';


class ChatRepository extends BaseRepository{
  BaseChatProvider chatProvider = ChatProvider();
  Stream<List<Conversation>> getConversations() => chatProvider.getConversations();
  Stream<List<Chat>> getChats() => chatProvider.getChats();
  Stream<List<Message>> getMessages(String chatId) => chatProvider.getMessages(chatId);
  Future<List<Message>> getPreviousMessages(
          String chatId, Message prevMessage) =>
      chatProvider.getPreviousMessages(chatId, prevMessage);

  Future<List<Message>> getAttachments(String chatId, int type) => chatProvider.getAttachments(chatId, type);

  Future<void> sendMessage(String chatId, Message message)=>chatProvider.sendMessage(chatId, message);

  Future<String> getChatIdByUsername(String username) =>
      chatProvider.getChatIdByUsername(username);

  Future<void> createChatIdForContact(MessioUser user) =>
      chatProvider.createChatIdForContact(user);

  @override
  void dispose() {
    chatProvider.dispose();
  }
}
