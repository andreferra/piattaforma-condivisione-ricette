import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';

class FirebaseRepository {
  final _firestore = FirebaseFirestore.instance;

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
  Future<void> updateProfile(AuthUser user) {
    return _firestore
        .collection('users')
        .doc(user.uid)
        .update(user.toDocument());
  }
}

class UpdateProfileFailure implements Exception {
  final String code;

  const UpdateProfileFailure(this.code);
}
