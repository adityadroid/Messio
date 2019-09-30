import 'package:equatable/equatable.dart';
import 'package:messio/models/Conversation.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState([List props = const <dynamic>[]]) : super(props);
}

class InitialHomeState extends HomeState {}

class FetchingHomeChatsState extends HomeState{
  @override
  String toString() => 'FetchingHomeChatsState';
}
class FetchedHomeChatsState extends HomeState{
  final List<Conversation> conversations;

  FetchedHomeChatsState(this.conversations);

  @override
  String toString() => 'FetchedHomeChatsState';
}
