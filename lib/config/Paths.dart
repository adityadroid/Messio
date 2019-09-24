import 'package:file_picker/file_picker.dart';

class Paths{

  /*
  Firebase paths
   */
  static const String profilePicturePath = 'profile_pictures';
  static const String imageAttachmentsPath = 'images';
  static const String videoAttachmentsPath = 'videos';
  static const String fileAttachmentsPath = 'files';
  static const String usersPath = '/users';
  static const String contactsPath = 'contacts';
  static const String usernameUidMapPath = '/username_uid_map';
  static const String chatsPath = '/chats';
  static const String chat_messages = '/chat_messages';
  static const String messagesPath = 'messages';

  static String getAttachmentPathByFileType(FileType fileType){
    if(fileType == FileType.IMAGE)
      return imageAttachmentsPath;
    else if(fileType == FileType.VIDEO)
      return videoAttachmentsPath;
    else
      return fileAttachmentsPath;
  }
}