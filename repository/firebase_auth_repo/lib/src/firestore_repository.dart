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
        "numero_recensioni" : 0,
        "media_recensioni" : 0.0,
        "numero_like" : 0,
        "numero_commenti" : 0,
        "commenti" : [],
        "like" : [],
        "numero_condivisioni" : 0,
        "numero_visualizzazioni" : 0,
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
}
