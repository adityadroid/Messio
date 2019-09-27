import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/utils/VideoThumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedObjects {
  static CachedSharedPreferences prefs;

  /*
  Supporting only for android for now
   */
  static downloadFile(String fileUrl,String fileName) async {

    await FlutterDownloader.enqueue(
      url: fileUrl,
      fileName: fileName,
      savedDir: Constants.downloadsDirPath,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
  }
    static Future<File>  getThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: Constants.cacheDirPath,
      imageFormat: ImageFormat.WEBP,
      maxHeightOrWidth: 0,
      quality: 30,
    );
    final file = File(thumbnail);
    return file;
  }

  static int getTypeFromFileType(FileType fileType) {
    if (fileType == FileType.IMAGE)
      return 1;
    else if (fileType == FileType.VIDEO)
      return 2;
    else
      return 3;
  }
}

class CachedSharedPreferences {
  static SharedPreferences sharedPreferences;
  static CachedSharedPreferences instance;
  static final cachedKeyList = {
    Constants.sessionUid,
    Constants.sessionUsername,
    Constants.sessionName
  };
  static Map<String, dynamic> map = Map();

  static Future<CachedSharedPreferences> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    for (String key in cachedKeyList) {
      map[key] = sharedPreferences.getString(key);
    }
    if (instance == null) instance = CachedSharedPreferences();
    return instance;
  }

  String getString(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    bool result = await sharedPreferences.setString(key, value);
    if (result) map[key] = value;
    return result;
  }
}
