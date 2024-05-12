import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// `StorageRepository` is a class that handles the storage operations with Firebase.
/// It uses the Firebase Storage instance to perform these operations.
class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// This method is used to upload a file to Firebase Storage.
  ///
  /// It takes in a `path` where the file needs to be stored and the `file` itself.
  /// It returns a `Future<String>` which is the URL of the uploaded file.
  ///
  /// If there is any error during the upload, it throws a `StorageException` with the error message.
  Future<String> uploadFile(String path, Uint8List? xfile) async {
    try {
      Reference ref = _storage.ref().child(path).child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(xfile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw StorageException(message: e.toString());
    }
  }

  /// Uploads multiple files to Firebase Storage.
  ///
  /// This method takes a `path` and a list of `files` as parameters. The `path` is the location
  /// in Firebase Storage where the files need to be stored. The `files` parameter is a list of
  /// files (in Uint8List format) that need to be uploaded.
  Future<List<String>> uploadMultipleFiles(String path, List<Uint8List> files) async {
    List<String> urls = [];
    for (int i = 0; i < files.length; i++) {
      urls.add(await uploadFile(path, files[i]));
    }
    return urls;
  }
  /// This method is used to delete a file from Firebase Storage.
  Future<void> eliminaImgStorage(String child) async {
    try {
      Reference ref = _storage.ref().child(child).child(_auth.currentUser!.uid);
      await ref.delete();
      print("Immagine eliminata");
    } catch (e) {
      print(e);
    }
  }
}

class StorageException implements Exception {
  final String message;

  StorageException({required this.message});
}
