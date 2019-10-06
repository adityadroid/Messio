

import 'package:messio/models/Message.dart';

List<Map> toListOfMap(List<dynamic> items){
  List<Map> result = List();
  items.forEach((item){
    result.add(item.toMap());
  });
  return result;
}
List<Message> messagesFromListOfMap(List<dynamic> result){
  List<Message> items = List();
  result.forEach((data)=>items.add(Message.fromMap(data)));
  return items;
}
