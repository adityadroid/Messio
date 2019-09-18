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

class FetchedMessagesState extends ChatState {
  final List<Message> messages;

  FetchedMessagesState(this.messages) : super([messages]);

  @override
  String toString() => 'FetchedMessagesState';
}

class ErrorState extends ChatState {
  final Exception exception;

  ErrorState(this.exception) : super([exception]);

  @override
  String toString() => 'ErrorState';
}

class FetchedContactDetailsState extends ChatState {
  final User user;

  FetchedContactDetailsState(this.user) : super([user]);

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
