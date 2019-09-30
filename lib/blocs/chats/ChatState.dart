import 'package:equatable/equatable.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatState extends Equatable {
  ChatState([List props = const <dynamic>[]]) : super(props);
}

class InitialChatState extends ChatState {}

class FetchedChatListState extends ChatState {
  final List<Chat> chatList;

  FetchedChatListState(this.chatList) : super([chatList]);

  @override
  String toString() => 'FetchedChatListState';
}
class FetchingMessageState extends ChatState{
  @override
  String toString() => 'FetchingMessageState';
}


class FetchedMessagesState extends ChatState {
  final List<Message> messages;
  final String username;
  final isPrevious;
  FetchedMessagesState(this.messages,this.username, {this.isPrevious}) : super([messages,username,isPrevious]);

  @override
  String toString() => 'FetchedMessagesState {messages: ${messages.length}, username: $username, isPrevious: $isPrevious}';
}

class ErrorState extends ChatState {
  final Exception exception;

  ErrorState(this.exception) : super([exception]);

  @override
  String toString() => 'ErrorState';
}

class FetchedContactDetailsState extends ChatState {
  final User user;
  final String username;
  FetchedContactDetailsState(this.user,this.username) : super([user,username]);

  @override
  String toString() => 'FetchedContactDetailsState';
}

class PageChangedState extends ChatState {
  final int index;
  final Chat activeChat;
  PageChangedState(this.index, this.activeChat) : super([index, activeChat]);

  @override
  String toString() => 'PageChangedState';
}

class ToggleEmojiKeyboardState extends ChatState{
  final bool showEmojiKeyboard;

  ToggleEmojiKeyboardState(this.showEmojiKeyboard): super([showEmojiKeyboard]);

  @override
  String toString() => 'ToggleEmojiKeyboardState';
}
