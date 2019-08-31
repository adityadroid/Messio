import 'package:flutter_test/flutter_test.dart';
import 'package:messio/providers/StorageProvider.dart';
import 'package:mockito/mockito.dart';

import '../mock/FirebaseMock.dart';
import '../mock/IOMock.dart';

void main() {
  group('StorageProvider', () {
    FirebaseStorageMock firebaseStorage = FirebaseStorageMock();
    StorageReferenceMock storageReference = StorageReferenceMock();
    StorageReferenceMock rootReference =
        StorageReferenceMock(childReference: storageReference);
    StorageReferenceMock fileReference = StorageReferenceMock();
    StorageUploadTaskMock storageUploadTask = StorageUploadTaskMock();
    StorageTaskSnapshotMock storageTaskSnapshot = StorageTaskSnapshotMock();
    String resultUrl = "http://www.adityag.me/";
    StorageProvider storageProvider =
        StorageProvider(firebaseStorage: firebaseStorage);
    test('Testing if uploadImage returns a url', () async {
      when(firebaseStorage.ref()).thenReturn(rootReference);
      when(storageReference.putFile(any)).thenReturn(storageUploadTask);
      when(storageUploadTask.onComplete).thenAnswer(
          (_) => Future<StorageTaskSnapshotMock>.value(storageTaskSnapshot));
      when(storageTaskSnapshot.ref).thenReturn(fileReference);
      when(fileReference.getDownloadURL())
          .thenAnswer((_) => Future<String>.value(resultUrl));

      expect(await storageProvider.uploadImage(MockFile(), ''), resultUrl);
    });
  });
}
