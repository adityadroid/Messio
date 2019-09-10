import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ContactsEvent extends Equatable {
  ContactsEvent([List props = const <dynamic>[]]) : super(props);
}

class FetchContactsEvent extends ContactsEvent{
  @override
  String toString() => 'FetchContactsEvent';
}

class AddContactEvent extends ContactsEvent {
  final String username;
  AddContactEvent({@required this.username});
  @override
  String toString() => 'AddContactEvent';
}

class ClickedContactEvent extends ContactsEvent {
  @override
  String toString() => 'ClickedContactEvent';
}
