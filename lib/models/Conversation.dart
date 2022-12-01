import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:messio/utils/document_snapshot_extension.dart';

class Conversation {
  String chatId;
  MessioUser user;
  Message latestMessage;

  Conversation(this.chatId, this.user, this.latestMessage);

  factory Conversation.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.dataAsMap;
    List<String> members = List.from(data['members']);
    String selfUsername =
        SharedObjects.prefs.getString(Constants.sessionUsername);
    MessioUser contact;
    for (int i = 0; i < members.length; i++) {
      if (members[i] != selfUsername) {
        final userDetails = Map<String,dynamic>.from((data['membersData'])[i]);
        contact = MessioUser.fromMap(userDetails);
      }
    }
    return Conversation(
        doc.id, contact, Message.fromMap(Map.from(data['latestMessage'])));
  }

  @override
  String toString() =>
      '{ user= $user, chatId = $chatId, latestMessage = $latestMessage}';
}
