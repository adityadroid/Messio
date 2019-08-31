import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messio/providers/BaseProviders.dart';

class StorageProvider extends BaseStorageProvider{
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageProvider({this.firebaseStorage});
  @override
  Future<String> uploadImage(File file, String path) async{
    StorageReference reference = firebaseStorage.ref().child(path); // get a reference to the path of the image directory
    StorageUploadTask uploadTask = reference.putFile(file); // put the file in the path
    StorageTaskSnapshot result = await uploadTask.onComplete; // wait for the upload to complete
    String url = await result.ref.getDownloadURL(); //retrieve the download link and return it
    return url;
  }
}