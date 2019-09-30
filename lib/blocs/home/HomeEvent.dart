import 'package:equatable/equatable.dart';
import 'package:messio/models/Conversation.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const <dynamic>[]]) : super(props);
}
class FetchHomeChatsEvent extends HomeEvent{
  @override
  String toString() => 'FetchHomeChatsEvent';
}
class ReceivedChatsEvent extends HomeEvent{
  final List<Conversation> conversations;
  ReceivedChatsEvent(this.conversations);

  @override
  String toString() => 'ReceivedChatsEvent';

}