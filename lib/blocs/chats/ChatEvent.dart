import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:messio/models/Message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const <dynamic>[]]) : super(props);
}

class FetchMessagesEvent extends ChatEvent{
  final String chatId;

  FetchMessagesEvent(this.chatId): super([chatId]);

  @override
  String toString() => 'FetchMessagesEvent';
}

class ReceivedMessagesEvent extends ChatEvent{
  final List<Message> messages;

  ReceivedMessagesEvent(this.messages): super([messages]);

  @override
  String toString() => 'ReceivedMessagesEvent';
}
class SendTextMessageEvent extends ChatEvent {
  final String chatId;
  final Message message;

  SendTextMessageEvent(this.chatId, this.message) : super([chatId, message]);

  @override
  String toString() => 'SendTextMessageEvent';
}

class PickedAttachmentEvent extends ChatEvent {
  final String chatId;
  final File file;
  final FileType fileType;

  PickedAttachmentEvent(this.chatId,this.file, this.fileType) : super([chatId, file, fileType]);

  @override
  String toString() => 'PickedAttachmentEvent';
}
