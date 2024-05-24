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

class DeleteCommentFailure implements Exception {
  final String code;

  const DeleteCommentFailure(this.code);
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
        url = await _storage.uploadFile(
            'foto_profilo/${user.uid}', file, user.uid);
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
          'cover_images/$uuidRicetta',
          state.coverImage!,
          "${uuidRicetta}cover");
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
  Future<String> addReply(
      Map reply, String recipesId, String idCommentoPadre) async {
    try {
      print('Adding reply to comment with id: $idCommentoPadre');
      var recipeDoc =
          await _firestore.collection('recipes').doc(recipesId).get();
      var commenti = List<Map<String, dynamic>>.from(recipeDoc['commenti']);
      var commentIndex = commenti
          .indexWhere((commento) => commento['idCommento'] == idCommentoPadre);
      if (commentIndex != -1) {
        var commento = commenti[commentIndex];
        if (commento['risposte'] == null) {
          commento['risposte'] = [reply];
        } else {
          commento['risposte'].add(reply);
        }
        commenti[commentIndex] = commento;
        await _firestore.collection('recipes').doc(recipesId).update({
          'commenti': commenti,
        });
        return 'ok';
      } else {
        print('No comment found with id: $idCommentoPadre');
        return 'error';
      }
    } on FirebaseException catch (e) {
      print(e);
      return 'error';
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  /// Delete comments
  Future<String> deleteComment(String recipesId, String idCommento) async {
    try {
      print('Deleting comment with id: $idCommento');
      var recipeDoc =
          await _firestore.collection('recipes').doc(recipesId).get();
      var commenti = List<Map<String, dynamic>>.from(recipeDoc['commenti']);
      var commentIndex = commenti
          .indexWhere((commento) => commento['idCommento'] == idCommento);
      if (commentIndex != -1) {
        commenti.removeAt(commentIndex);
        await _firestore.collection('recipes').doc(recipesId).update({
          'commenti': commenti,
          'numero_commenti': FieldValue.increment(-1),
        });
        return 'ok';
      }
      return 'error';
    } on FirebaseException catch (e) {
      print(e);
      return Future.error(DeleteCommentFailure(e.code));
    } catch (e) {
      print(e);
      return Future.error(DeleteCommentFailure(e.toString()));
    }
  }

  /// Upload image comment to storage
  Future<List<String>> uploadImageComment(
      String recipesId, String commentID, List<Uint8List> imageFile) async {
    try {
      List<String> url = [];
      url = await _storage.uploadMultipleFiles(
          'comment_images/$recipesId/$commentID', imageFile);

      return url;
    } on StorageException catch (e) {
      return Future.error(AddCommentFailure(e.message));
    } catch (e) {
      return Future.error(AddCommentFailure(e.toString()));
    }
  }

  /// Follow a user
  Future<String> followUser(String user1, String user2) async {
    try {
      await _firestore.collection('users').doc(user2).update({
        'follower': FieldValue.arrayUnion([user1])
      });
      await _firestore.collection('users').doc(user1).update({
        'following': FieldValue.arrayUnion([user2])
      });
      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Unfollow a user
  Future<String> unfollowUser(String user1, String user2) async {
    try {
      await _firestore.collection('users').doc(user2).update({
        'follower': FieldValue.arrayRemove([user1])
      });
      await _firestore.collection('users').doc(user1).update({
        'following': FieldValue.arrayRemove([user2])
      });
      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Add a notification to the user
  Future<String> addNotification(String user1, String user2) async {
    try {
      await _firestore.collection('users').doc(user2).update({
        'listaNotifiche': FieldValue.arrayUnion([user1])
      });
      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Delete a notification from the user
  Future<String> deleteNotification(String user1, String user2) async {
    try {
      await _firestore.collection('users').doc(user2).update({
        'listaNotifiche': FieldValue.arrayRemove([user1])
      });
      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  ///Controlle se la chat esiste se no creala
  Future<void> checkChat(String id, String mioId) async {
    bool isEmpty = true;
    try {
      final chat =
          await _firestore.collection('messaggi').where('id', whereIn: [
        '$id-$mioId',
        '$mioId-$id',
      ]).get();
      if (chat.docs.isNotEmpty) {
        isEmpty = false;
      }

      if (isEmpty) {
        await _firestore.collection('messaggi').add({
          'id': '$id-$mioId',
          'messaggi': [],
        });
      }
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Send a message
  Future<String> sendMessage(message, String id, String mioID) async {
    try {
      await _firestore
          .collection('messaggi')
          .where('id', whereIn: [
            '$id-$mioID',
            '$mioID-$id',
          ])
          .get()
          .then((value) {
            if (value.docs.isNotEmpty) {
              _firestore.collection('messaggi').doc(value.docs[0].id).update({
                'messaggi': FieldValue.arrayUnion([message])
              });
            }
          });
      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// set all messages as read in the chat
  Future<void> setAllMessagesAsRead(String id, String mioID) async {
    try {
      await _firestore
          .collection('messaggi')
          .where('id', whereIn: [
            '$id-$mioID',
            '$mioID-$id',
          ])
          .get()
          .then((value) async {
            if (value.docs.isEmpty) {
              return;
            }

            List<dynamic> messages = value.docs[0].data()['messaggi'];
            for (var i = 0; i < messages.length; i++) {
              if (messages[i]['senderId'] != mioID) {
                messages[i]['isRead'] = true;
              }
            }

            await _firestore
                .collection('messaggi')
                .doc(value.docs[0].id)
                .update({
              'messaggi': messages,
            });
          });
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Update user log status and last access
  Future<void> updateUserLogStatus(String uid, bool isLogged) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isLogged': isLogged,
        'dataUltimoAccesso': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Update like number and add user id to like list
  /// [isLike] = true if the user liked the recipe, false if the user unliked the recipe
  Future<String> updateLike(String recipeId, String userId, bool isLike) async {
    try {
      String res = 'error';
      await _firestore.collection('recipes').doc(recipeId).update({
        'numero_like':
            !isLike ? FieldValue.increment(1) : FieldValue.increment(-1),
        'like': !isLike
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId]),
      }).then((value) {
        res = isLike ? 'unlike' : 'like';
      });
      return res;
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Get like list
  Future<List<String>> getLikeList(String recipeId) async {
    try {
      List<String> likeList = [];
      await _firestore.collection('recipes').doc(recipeId).get().then((value) {
        likeList = List<String>.from(value.data()!['like']);
      });
      return likeList;
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }
}
