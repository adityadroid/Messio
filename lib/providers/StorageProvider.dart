import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messio/providers/BaseProviders.dart';

class StorageProvider extends BaseStorageProvider{
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  @override
  Future<String> uploadImage(File file, String path) async{
    StorageReference reference = firebaseStorage.ref().child(path);
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot result = await uploadTask.onComplete;
    String url = await result.ref.getDownloadURL();
    print(url);
    return url;
  }
}