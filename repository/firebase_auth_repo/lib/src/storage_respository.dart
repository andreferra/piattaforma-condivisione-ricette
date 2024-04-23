import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// `StorageRepository` is a class that handles the storage operations with Firebase.
/// It uses the Firebase Storage instance to perform these operations.
class StorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// This method is used to upload a file to Firebase Storage.
  ///
  /// It takes in a `path` where the file needs to be stored and the `file` itself.
  /// It returns a `Future<String>` which is the URL of the uploaded file.
  ///
  /// If there is any error during the upload, it throws a `StorageException` with the error message.
  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw StorageException(message: e.toString());
    }
  }
}

class StorageException implements Exception {
  final String message;

  StorageException({required this.message});
}
