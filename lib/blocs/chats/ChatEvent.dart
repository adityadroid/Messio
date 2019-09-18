import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const <dynamic>[]]) : super(props);
}


//triggered to fetch list of chats
class FetchChatListEvent extends ChatEvent {
  @override
  String toString() => 'FetchChatListEvent';
}

//triggered when stream containing list of chats has new data
class ReceivedChatsEvent extends ChatEvent {
  final List<Chat> chatList;

  ReceivedChatsEvent(this.chatList);

  @override
  String toString() => 'ReceivedChatsEvent';
}

//triggered to get details of currently open conversation
class FetchConversationDetailsEvent extends ChatEvent {
  final Chat chat;

  FetchConversationDetailsEvent(this.chat) : super([chat]);

  @override
  String toString() => 'FetchConversationDetailsEvent';
}

//triggered to fetch messages of chat
class FetchMessagesEvent extends ChatEvent {
  final Chat chat;

  FetchMessagesEvent(this.chat) : super([chat]);

  @override
  String toString() => 'FetchMessagesEvent';
}

//triggered when messages stream has new data
class ReceivedMessagesEvent extends ChatEvent {
  final List<Message> messages;

  ReceivedMessagesEvent(this.messages) : super([messages]);

  @override
  String toString() => 'ReceivedMessagesEvent';
}

//triggered to send new text message
class SendTextMessageEvent extends ChatEvent {
  final String message;

  SendTextMessageEvent(this.message) : super([message]);

  @override
  String toString() => 'SendTextMessageEvent';
}

//triggered to send attachment
class SendAttachmentEvent extends ChatEvent {
  final String chatId;
  final File file;
  final FileType fileType;

  SendAttachmentEvent(this.chatId, this.file, this.fileType)
      : super([chatId, file, fileType]);

  @override
  String toString() => 'SendAttachmentEvent';
}

//triggered on page change
class PageChangedEvent extends ChatEvent {
  final int index;
  final Chat activeChat;
  PageChangedEvent(this.index, this.activeChat) : super([index, activeChat]);

  @override
  String toString() => 'PageChangedEvent';
}
