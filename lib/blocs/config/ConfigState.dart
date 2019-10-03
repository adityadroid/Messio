import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConfigState extends Equatable {
  ConfigState([List props = const <dynamic>[]]) : super(props);
}

class ConfigChangeState extends ConfigState{
  final String key;
  final bool value;
  ConfigChangeState(this.key,this.value): super([key,value]);
}
class UnConfigState extends ConfigState{}
