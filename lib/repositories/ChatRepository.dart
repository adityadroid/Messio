import 'package:messio/models/Chat.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/providers/ChatProvider.dart';

class ChatRepository{
  BaseChatProvider chatProvider = ChatProvider();
  Stream<List<Chat>> getChats() => chatProvider.getChats();
  Stream<List<Message>> getMessages(String chatId) => chatProvider.getMessages(chatId);
  Future<void> sendMessage(String chatId, Message message) => chatProvider.sendMessage(chatId, message);
}