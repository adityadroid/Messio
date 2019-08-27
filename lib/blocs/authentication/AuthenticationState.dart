import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const <dynamic>[]]) : super(props);
}

class Uninitialized extends AuthenticationState{
  @override
  String toString() => 'Uninitialized';
}

class AuthInProgress extends AuthenticationState{
  @override
  String toString() => 'AuthInProgress';
}

class Authenticated extends AuthenticationState{
  @override
  String toString() => 'Authenticated';
}

class UnAuthenticated extends AuthenticationState{
  @override
  String toString() => 'UnAuthenticated';
}