import 'package:flutter_test/flutter_test.dart';
import 'package:messio/providers/storage_provider.dart';
import 'package:messio/utils/shared_objects.dart';
import 'package:mockito/mockito.dart';

import '../mock/firebase_mock.dart';
import '../mock/io_mock.dart';
import '../mock/shared_objects_mock.dart';
void main() {
  group('StorageProvider', () {
    FirebaseStorageMock firebaseStorage = FirebaseStorageMock(); //Create the mock objects required
    StorageReferenceMock storageReference = StorageReferenceMock();
    StorageReferenceMock rootReference =
        StorageReferenceMock(childReference: storageReference);
    StorageReferenceMock fileReference = StorageReferenceMock();
    StorageUploadTaskMock storageUploadTask = StorageUploadTaskMock();
    StorageTaskSnapshotMock storageTaskSnapshot = StorageTaskSnapshotMock();
    MockFile mockFile = MockFile();
    String resultUrl = "http://www.adityag.me/";
    StorageProvider storageProvider =
        StorageProvider(firebaseStorage: firebaseStorage);

    test('Testing if uploadImage returns a url', () async {
      SharedPreferencesMock sharedPreferencesMock = SharedPreferencesMock();
      SharedObjects.prefs = sharedPreferencesMock;
      when(sharedPreferencesMock.getString(any)).thenReturn('uid');
      when(SharedObjects.prefs.setString(any, any)).thenAnswer((_)=>Future.value(true));
      when(mockFile.path).thenReturn("/storage/file.jpg"); //this is necessary because basename() method from path.dart uses the path of the file to return its basename
      when(firebaseStorage.ref()).thenReturn(rootReference);
      when(storageReference.putFile(any)).thenReturn(storageUploadTask);
      when(storageUploadTask.onComplete).thenAnswer(
          (_) => Future<StorageTaskSnapshotMock>.value(storageTaskSnapshot));
      when(storageTaskSnapshot.ref).thenReturn(fileReference);
      when(fileReference.getDownloadURL())
          .thenAnswer((_) => Future<String>.value(resultUrl));

      expect(await storageProvider.uploadFile(mockFile, ''), resultUrl);
    });
  });
}
