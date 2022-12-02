import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messio/providers/base_providers.dart';

class StorageProvider extends BaseStorageProvider{
  final FirebaseStorage firebaseStorage;
  StorageProvider({FirebaseStorage firebaseStorage}): firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;
  @override
  Future<String> uploadFile(File file, String path) async{
    String fileName = basename(file.path);
    final miliSecs = DateTime.now().millisecondsSinceEpoch;
    final reference = firebaseStorage.ref().child('$path/$miliSecs\_$fileName'); // get a reference to the path of the image directory
    String uploadPath = reference.fullPath;
    print('uploading to $uploadPath');
    final uploadTask = reference.putFile(file); // put the file in the path
    final result = await uploadTask.whenComplete(()=>{}); // wait for the upload to complete
    String url = await result.ref.getDownloadURL(); //retrieve the download link and return it
    return url;
  }

  @override
  void dispose() {}
}