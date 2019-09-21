import 'package:messio/models/Chat.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/providers/ChatProvider.dart';

class ChatRepository {
  BaseChatProvider chatProvider = ChatProvider();

  Stream<List<Chat>> getChats() => chatProvider.getChats();

  Stream<List<Message>> getMessages(String chatId) =>
      chatProvider.getMessages(chatId);

  Future<List<Message>> getPreviousMessages(
          String chatId, Message prevMessage) =>
      chatProvider.getPreviousMessages(chatId, prevMessage);

  Future<void> sendMessage(String chatId, Message message) =>
      chatProvider.sendMessage(chatId, message);

  Future<String> getChatIdByUsername(String username) =>
      chatProvider.getChatIdByUsername(username);

  Future<void> createChatIdForContact(User user) =>
      chatProvider.createChatIdForContact(user);
}
