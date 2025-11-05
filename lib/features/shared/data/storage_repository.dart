import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  StorageRepository(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadResearchFile({
    required String userId,
    required String fileName,
    File? file,
    Uint8List? bytes,
  }) async {
    final ref = _storage.ref().child('research_papers').child(userId).child(fileName);
    UploadTask uploadTask;
    if (file != null) {
      uploadTask = ref.putFile(file);
    } else if (bytes != null) {
      uploadTask = ref.putData(bytes);
    } else {
      throw ArgumentError('Either file or bytes must be provided for upload.');
    }
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  Future<void> deleteFile(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } on FirebaseException {
      // Ignore storage exceptions for deleted files.
    }
  }
}
