import 'dart:io';

import 'package:messio/providers/storage_provider.dart';
import 'package:messio/repositories/base_repository.dart';

class StorageRepository extends BaseRepository{
  StorageProvider storageProvider = StorageProvider();
  Future<String> uploadFile(File file, String path) => storageProvider.uploadFile(file, path);

  @override
  void dispose() {
storageProvider.dispose();
  }
}