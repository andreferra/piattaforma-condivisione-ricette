import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:firebase_auth_repo/src/storage_respository.dart';

class UpdateProfileFailure implements Exception {
  final String code;

  const UpdateProfileFailure(this.code);
}

class AddRecipesFailure implements Exception {
  final String code;

  const AddRecipesFailure(this.code);
}

class UpdateVisualizationsFailure implements Exception {
  final String code;

  const UpdateVisualizationsFailure(this.code);
}

class UpdateSettingFailure implements Exception {
  final String code;

  const UpdateSettingFailure(this.code);
}

class AddCommentFailure implements Exception {
  final String code;

  const AddCommentFailure(this.code);
}

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
  Future<void> updateProfile(AuthUser user, Uint8List? file) async {
    try {
      late String? url = user.photoURL;
      if (file != null) {
        url = await _storage.uploadFile('foto_profilo/${user.uid}', file);
        user = user.copyWith(photoURL: url);
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

  /// Delete user from database
  Future<void> deleteUserFromDatabase(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Adds a recipe to the database.
  Future<String> addRecipe(AuthUser user, state, String uuidRicetta) async {
    try {
      String coverImageUrl = await _storage.uploadFile(
          'cover_images/$uuidRicetta', state.coverImage!);
      List<String> stepImagesUrl = await _storage.uploadMultipleFiles(
          'step_images/$uuidRicetta', state.immagini);
      final recipe = {
        'uid': uuidRicetta,
        'nome_piatto': state.nomePiatto,
        'descrizione': state.descrizione,
        'cover_image': coverImageUrl,
        'tempo_preparazione': state.tempoPreparazione,
        'porzioni': state.porzioni,
        'difficolta': state.difficolta,
        'ingredienti': state.ingredienti,
        'tag': state.tag,
        'allergie': state.allergie,
        'step_images': stepImagesUrl,
        'step_texts': state.passaggi,
        'user_id': user.uid,
        "data_creazione": FieldValue.serverTimestamp(),
        "numero_recensioni": 0,
        "media_recensioni": 0.0,
        "numero_like": 0,
        "numero_commenti": 0,
        "commenti": [],
        "like": [],
        "numero_condivisioni": 0,
        "numero_visualizzazioni": 0,
      };

      //aggiungi ricetta al database
      await _firestore.collection('recipes').doc(uuidRicetta).set(recipe);

      // aggiungi id ricetta all'utente
      await _firestore.collection('users').doc(user.uid).update({
        'recipes': FieldValue.arrayUnion([uuidRicetta])
      });

      return uuidRicetta;
    } on FirebaseException catch (e) {
      return Future.error(AddRecipesFailure(e.code));
    } catch (e) {
      return Future.error(AddRecipesFailure(e.toString()));
    }
  }

  /// Check if the nickname is already in use
  Future<bool> checkNickname(String nickname) async {
    final query = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .get();
    return query.docs.isNotEmpty;
  }

  /// Updates the user's settings.
  Future<void> updateUserSetting(
      String email, String password, bool notification, String userid) async {
    try {
      await _firestore.collection('users').doc(userid).update({
        'email': email,
        'password': password,
        'notification': notification,
      });
    } on FirebaseException catch (e) {
      return Future.error(UpdateSettingFailure(e.code));
    } catch (e) {
      return Future.error(UpdateSettingFailure(e.toString()));
    }
  }

  /// Update the recipes visualizations
  Future<void> updateVisualizations(String recipeId) async {
    try {
      final recipe = await _firestore.collection('recipes').doc(recipeId).get();
      final visualizzazioni = recipe['numero_visualizzazioni'] + 1;
      await _firestore.collection('recipes').doc(recipeId).update({
        'numero_visualizzazioni': visualizzazioni,
      });
    } on FirebaseException catch (e) {
      return Future.error(UpdateVisualizationsFailure(e.code));
    } catch (e) {
      return Future.error(UpdateVisualizationsFailure(e.toString()));
    }
  }

  /// Adds a comment to the recipe.
  Future<void> addComment(Map comment, String recipesId) async {
    try {
      await _firestore.collection('recipes').doc(recipesId).set({
        'commenti': FieldValue.arrayUnion([comment]),
        'numero_commenti': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      return Future.error(AddCommentFailure(e.code));
    } catch (e) {
      return Future.error(AddCommentFailure(e.toString()));
    }
  }

  /// Adds a reply to the comment.
  Future<void> addReply(Map comment, String recipesId, String idCommentoPadre) async {
    try {
      var querySnapshot = await _firestore
          .collection('recipes')
          .doc(recipesId)
          .collection('commenti')
          .where('idCommento', isEqualTo: idCommentoPadre)
          .get();
      var docToUpdate = querySnapshot.docs.first;
      await docToUpdate.reference.update({
        'risposte': FieldValue.arrayUnion([comment])
      });
    } on FirebaseException catch (e) {
      return Future.error(AddCommentFailure(e.code));
    } catch (e) {
      return Future.error(AddCommentFailure(e.toString()));
    }
  }
}
