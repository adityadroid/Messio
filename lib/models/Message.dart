import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/utils/SharedObjects.dart';


abstract class Message  {
  int timeStamp;
  String senderName;
  String senderUsername;
  bool isSelf;
  String documentId;
  Message(this.timeStamp, this.senderName, this.senderUsername);

  factory Message.fromFireStore(DocumentSnapshot doc) {
    final int type = doc.data['type'];
    Message message;
    switch (type) {
      case 0:
        message = TextMessage.fromFirestore(doc);
        break;
      case 1:
        message = ImageMessage.fromFirestore(doc);
        break;
      case 2:
        message = VideoMessage.fromFirestore(doc);
        break;
      case 3:
        message = FileMessage.fromFirestore(doc);
    }
    message.isSelf = SharedObjects.prefs.getString(Constants.sessionUsername) ==
        message.senderUsername;
    message.documentId = doc.documentID;
    return message;
  }

  factory Message.fromMap(Map map) {
    final int type = map['type'];
    Message message;
    switch (type) {
      case 0:
        message = TextMessage.fromMap(map);
        break;
      case 1:
        message = ImageMessage.fromMap(map);
        break;
      case 2:
        message = VideoMessage.fromMap(map);
        break;
      case 3:
        message = FileMessage.fromMap(map);
    }
    message.isSelf = SharedObjects.prefs.getString(Constants.sessionUsername) ==
        message.senderUsername;
    return message;
  }
  Map<String, dynamic> toMap();
}

class TextMessage extends Message {
  String text;
  TextMessage(this.text, timeStamp, senderName, senderUsername)
      : super(timeStamp, senderName, senderUsername);

  factory TextMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return TextMessage.fromMap(data);
  }
  factory TextMessage.fromMap(Map data) {
    return TextMessage(data['text'], data['timeStamp'], data['senderName'],
        data['senderUsername']);
  }
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['text'] = text;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 0;
    return map;
  }

  @override
  String toString() => '{ senderName : $senderName, senderUsername : $senderUsername, isSelf : $isSelf , timeStamp : $timeStamp, type : 3, text: $text }';


}

class ImageMessage extends Message {
  String imageUrl;
  String fileName;
  ImageMessage(this.imageUrl,this.fileName, timeStamp, senderName, senderUsername)
      : super(timeStamp, senderName, senderUsername);

  factory ImageMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
      return ImageMessage.fromMap(data);
  }
  factory ImageMessage.fromMap(Map data) {
    return ImageMessage(data['imageUrl'],data['fileName'], data['timeStamp'], data['senderName'],
        data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['imageUrl'] = imageUrl;
    map['fileName']= fileName;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 1;
    print('map $map');
    return map;
  }
  @override
  String toString() => '{ senderName : $senderName, senderUsername : $senderUsername, isSelf : $isSelf , timeStamp : $timeStamp, type : 3, fileName: $fileName, imageUrl : $imageUrl  }';

}


class VideoMessage extends Message {
  String videoUrl;
  String fileName;
  VideoMessage(this.videoUrl,this.fileName, timeStamp, senderName, senderUsername)
      : super(timeStamp, senderName, senderUsername);

  factory VideoMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
   return VideoMessage.fromMap(data);
  }
  factory VideoMessage.fromMap(Map data) {
    return VideoMessage(data['videoUrl'],data['fileName'], data['timeStamp'], data['senderName'],
        data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['videoUrl'] = videoUrl;
    map['fileName']= fileName;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 2;
    return map;
  }
  @override
  String toString() => '{ senderName : $senderName, senderUsername : $senderUsername, isSelf : $isSelf , timeStamp : $timeStamp, type : 3, fileName: $fileName, videoUrl : $videoUrl  }';


}

class FileMessage extends Message {
  String fileUrl;
  String fileName;
  FileMessage(this.fileUrl,this.fileName, timeStamp, senderName, senderUsername)
      : super(timeStamp, senderName, senderUsername);

  factory FileMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
   return FileMessage.fromMap(data);
  }
  factory FileMessage.fromMap(Map data) {
    return FileMessage(data['fileUrl'],data['fileName'], data['timeStamp'], data['senderName'],
        data['senderUsername']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['fileUrl'] = fileUrl;
    map['fileName']= fileName;
    map['timeStamp'] = timeStamp;
    map['senderName'] = senderName;
    map['senderUsername'] = senderUsername;
    map['type'] = 3;
    return map;
  }

  @override
  String toString() => '{ senderName : $senderName, senderUsername : $senderUsername, isSelf : $isSelf , timeStamp : $timeStamp, type : 3, fileName: $fileName, fileUrl : $fileUrl  }';

}
