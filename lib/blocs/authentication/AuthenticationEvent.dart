import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const <dynamic>[]]) : super(props);
}

class AppLaunched extends AuthenticationEvent{
  @override
  String toString() => 'AppLaunched';
}

class LoggedIn extends AuthenticationEvent{
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent{
  @override
  String toString() => 'LoggedOut';
}

