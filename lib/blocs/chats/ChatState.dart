import 'package:equatable/equatable.dart';
import 'package:messio/models/Message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatState extends Equatable {
  ChatState([List props = const <dynamic>[]]) : super(props);
}

class InitialChatState extends ChatState {}

class FetchedMessagesState extends ChatState{
  final List<Message> messages;
  FetchedMessagesState(this.messages): super([messages]);

  @override
  String toString() => 'FetchedMessagesState';
}
class ErrorState extends ChatState{
  final Exception exception;
  ErrorState(this.exception): super([exception]);

  @override
  String toString() => 'ErrorState';
}
