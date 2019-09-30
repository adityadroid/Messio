import 'dart:io';

import 'package:messio/providers/StorageProvider.dart';
import 'package:messio/repositories/BaseRepository.dart';

class StorageRepository extends BaseRepository{
  StorageProvider storageProvider = StorageProvider();
  Future<String> uploadFile(File file, String path) => storageProvider.uploadFile(file, path);

  @override
  void dispose() {
storageProvider.dispose();
  }
}