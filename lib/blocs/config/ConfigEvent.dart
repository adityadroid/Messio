import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConfigEvent extends Equatable {
  ConfigEvent([List props = const <dynamic>[]]) : super(props);
}

class ConfigValueChanged extends ConfigEvent{
  final String key;
  final bool value;
  ConfigValueChanged(this.key,this.value): super([key,value]);
}