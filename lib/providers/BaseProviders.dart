import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/models/Conversation.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';

abstract class BaseProvider{
  void dispose();
}
abstract class BaseAuthenticationProvider extends BaseProvider{
  Future<User> signInWithGoogle();
  Future<void> signOutUser();
  User getCurrentUser();
  bool isLoggedIn();
}

abstract class BaseUserDataProvider extends BaseProvider{
  Future<MessioUser> saveDetailsFromGoogleAuth(User user);
  Future<MessioUser> saveProfileDetails(String profileImageUrl, int age, String username);
  Future<bool> isProfileComplete();
  Stream<List<Contact>> getContacts();
  Future<void> addContact(String username);
  Future<MessioUser> getUser(String username);
  Future<String> getUidByUsername(String username);
  Future<void> updateProfilePicture(String profilePictureUrl);
}

abstract class BaseStorageProvider extends BaseProvider{
  Future<String> uploadFile(File file, String path);
}

abstract class BaseChatProvider extends BaseProvider{
  Stream<List<Conversation>> getConversations();
  Stream<List<Message>> getMessages(String chatId);
  Future<List<Message>> getPreviousMessages(String chatId, Message prevMessage);
  Future<List<Message>> getAttachments(String chatId, int type);
  Stream<List<Chat>> getChats();
  Future<void> sendMessage(String chatId, Message message);
  Future<String> getChatIdByUsername(String username);
  Future<void> createChatIdForContact(MessioUser user);
}
abstract class BaseDeviceStorageProvider extends BaseProvider{
  Future<File> getThumbnail(String videoUrl);
}