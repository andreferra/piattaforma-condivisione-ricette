import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:firebase_auth_repo/src/storage_respository.dart';

class FirebaseRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = StorageRepository();

  /// Saves the given [user] in the database.
  Future<void> saveUserInDatabase(AuthUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toDocument());
  }

  /// Fetches the current user from the database.
  Future<AuthUser> getUserFromDatabase(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    return AuthUser.fromDocument(userDoc.data()!);
  }

  /// Updates the profile of the current user.
  Future<void> updateProfile(AuthUser user, File? file) async {
    try {
      late String? url = user.photoURL;
      if (file != null)  {
        url = await _storage.uploadFile('foto_profilo/${user.uid}', file);
        user = user.copyWith(photoURL: url);
        print(url);
      }
      
      return _firestore
          .collection('users')
          .doc(user.uid)
          .update(user.toDocument());
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }
}

class UpdateProfileFailure implements Exception {
  final String code;

  const UpdateProfileFailure(this.code);
}
