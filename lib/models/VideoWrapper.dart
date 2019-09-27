import 'dart:io';

import 'Message.dart';

class VideoWrapper{
  final File file; //thumbnail for the video
  final VideoMessage videoMessage;
  VideoWrapper(this.file, this.videoMessage);

}