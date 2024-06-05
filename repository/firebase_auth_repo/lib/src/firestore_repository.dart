import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:firebase_auth_repo/src/storage_respository.dart';
import 'package:model_repo/model_repo.dart';

class UpdateProfileFailure implements Exception {
  final String code;

  const UpdateProfileFailure(this.code);

  @override
  String toString() {
    return 'UpdateProfileFailure: $code';
  }
}

class AddPointerFailure implements Exception {
  final String code;

  const AddPointerFailure(this.code);

  @override
  String toString() {
    return 'AddPointerFailure: $code';
  }
}

class UpdateRecipeFailure {
  final String message;

  UpdateRecipeFailure(this.message);

  @override
  String toString() {
    return 'UpdateRecipeFailure{message: $message}';
  }
}

class AddRecipeViewFailure implements Exception {
  final String code;

  const AddRecipeViewFailure(this.code);

  @override
  String toString() {
    return 'AddRecipeViewFailure: $code';
  }
}

class AddChallengeFailure implements Exception {
  final String code;

  const AddChallengeFailure(this.code);

  @override
  String toString() {
    return 'AddChallengeFailure: $code';
  }
}

class GameingFailure implements Exception {
  final String code;

  const GameingFailure(this.code);

  @override
  String toString() {
    return 'GameingFailure: $code';
  }
}

class AddRecipesFailure implements Exception {
  final String code;

  const AddRecipesFailure(this.code);
}

class NotificationFailure implements Exception {
  final String code;

  const NotificationFailure(this.code);
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

class GetRecipeFailure implements Exception {
  final String code;

  const GetRecipeFailure(this.code);

  @override
  String toString() {
    return 'GetRecipeFailure: $code';
  }
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
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      return AuthUser.fromDocument(userDoc.data()!);
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
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

  GameName checkUserName(Gaming game) {
    if (game.punti >= 0 && game.punti < 500) {
      return GameName.reginaDellaPasta;
    } else if (game.punti >= 500 && game.punti < 1000) {
      return GameName.maestroDiDolci;
    } else if (game.punti >= 1000 && game.punti < 2000) {
      return GameName.reDellaPizza;
    } else if (game.punti >= 2000 && game.punti < 4000) {
      return GameName.grillMaster5000;
    } else if (game.punti >= 4000 && game.punti <= 10000) {
      return GameName.sushiChef;
    } else {
      return game.gameName;
    }
  }

  /// Follow a user
  Future<String> followUser(
      String user1, String user2, notification, Gaming game) async {
    try {
      game = game.copyWith(
          punti: game.punti + 10, gameName: checkUserName(game), sfide: []);

      Map<String, dynamic> gameJson = game.toMap();

      await _firestore.collection('users').doc(user2).update({
        'follower': FieldValue.arrayUnion([user1]),
        'listaNotifiche': FieldValue.arrayUnion([notification]),
        'newNotifiche': true,
        'gaming': gameJson,
      });

      await _firestore.collection('users').doc(user1).update({
        'following': FieldValue.arrayUnion([user2]),
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
  Future<String> sendMessage(message, String id, String mioID, String type,
      Uint8List file, notification) async {
    try {
      switch (type) {
        case 'text':
          await _firestore
              .collection('messaggi')
              .where('id', whereIn: [
                '$id-$mioID',
                '$mioID-$id',
              ])
              .get()
              .then((value) {
                if (value.docs.isNotEmpty) {
                  _firestore
                      .collection('messaggi')
                      .doc(value.docs[0].id)
                      .update({
                    'messaggi': FieldValue.arrayUnion([message])
                  });
                } else {
                  _firestore.collection('messaggi').add({
                    'id': '$id-$mioID',
                    'messaggi': [message],
                  });
                }
              });
          break;
        case 'image':
          String url = await _storage.uploadFile(
              'chat_images/$id-$mioID', file, message['id']);
          message['message'] = url;
          await _firestore
              .collection('messaggi')
              .where('id', whereIn: [
                '$id-$mioID',
                '$mioID-$id',
              ])
              .get()
              .then((value) {
                if (value.docs.isNotEmpty) {
                  _firestore
                      .collection('messaggi')
                      .doc(value.docs[0].id)
                      .update({
                    'messaggi': FieldValue.arrayUnion([message])
                  });
                } else {
                  _firestore.collection('messaggi').add({
                    'id': '$id-$mioID',
                    'messaggi': [message],
                  });
                }
              });
          break;
        case 'recipe':
          await _firestore
              .collection('messaggi')
              .where('id', whereIn: [
                '$id-$mioID',
                '$mioID-$id',
              ])
              .get()
              .then((value) {
                if (value.docs.isNotEmpty) {
                  _firestore
                      .collection('messaggi')
                      .doc(value.docs[0].id)
                      .update({
                    'messaggi': FieldValue.arrayUnion([message])
                  });
                } else {
                  _firestore.collection('messaggi').add({
                    'id': '$id-$mioID',
                    'messaggi': [message],
                  });
                }
              });
          break;
        case 'user':
          await _firestore
              .collection('messaggi')
              .where('id', whereIn: [
                '$id-$mioID',
                '$mioID-$id',
              ])
              .get()
              .then((value) {
                if (value.docs.isNotEmpty) {
                  _firestore
                      .collection('messaggi')
                      .doc(value.docs[0].id)
                      .update({
                    'messaggi': FieldValue.arrayUnion([message])
                  });
                } else {
                  _firestore.collection('messaggi').add({
                    'id': '$id-$mioID',
                    'messaggi': [message],
                  });
                }
              });
          break;
        default:
          return 'error';
      }

      await _firestore.collection('users').doc(id).update({
        'listaNotifiche': FieldValue.arrayUnion([notification]),
        'newNotifiche': true,
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
  Future<String> updateLike(
      String recipeId,
      String userId,
      bool isLike,
      notification,
      String notificationAddId,
      Gaming gaming,
      bool gameActive) async {
    try {
      String res = 'error';
      Map<Object, Object> isLiked = {
        'numero_like': FieldValue.increment(1),
        'like': FieldValue.arrayUnion([userId]),
      };

      gaming = gaming.copyWith(
          punti: gaming.punti + 10, gameName: checkUserName(gaming));

      if (gameActive && !isLike) {
        await updateGamingData(notificationAddId, gaming);
      }

      Map<Object, Object> isUnliked = {
        'numero_like': FieldValue.increment(-1),
        'like': FieldValue.arrayRemove([userId]),
      };
      await _firestore
          .collection('recipes')
          .doc(recipeId)
          .update(!isLike ? isLiked : isUnliked)
          .then(
        (_) async {
          if (!isLike) {
            await _firestore.collection('users').doc(notificationAddId).update({
              'listaNotifiche': FieldValue.arrayUnion([notification]),
              'newNotifiche': true,
            });
          }
          res = isLike ? 'unlike' : 'like';
        },
      );
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

  /// Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Get recipe
  Future<DocumentSnapshot> getRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).get().then((value) {
        if (value.exists) {
          return value;
        }
      });
      return Future.error(const GetRecipeFailure('Recipe not found'));
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  /// Get all recipes
  Future<List<DocumentSnapshot>> getAllRecipes() async {
    try {
      List<DocumentSnapshot> recipes = [];
      await _firestore.collection('recipes').get().then((value) {
        recipes = value.docs;
      });
      return recipes;
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  /// Get all users
  Future<List<DocumentSnapshot>> getAllUsers() async {
    try {
      List<DocumentSnapshot> users = [];
      await _firestore.collection('users').get().then((value) {
        users = value.docs;
      });
      return users;
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Get all comments
  Future<List<Map<String, dynamic>>> getAllComments(String recipeId) async {
    try {
      List<Map<String, dynamic>> comments = [];
      await _firestore.collection('recipes').doc(recipeId).get().then((value) {
        comments = List<Map<String, dynamic>>.from(value.data()!['commenti']);
      });
      return comments;
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  Stream<DocumentSnapshot<Object?>>? streamRecipe(String message) {
    return _firestore.collection('recipes').doc(message).snapshots();
  }

  Stream<DocumentSnapshot<Object?>>? streamUser(String message) {
    return _firestore
        .collection('users')
        .doc(message)
        .snapshots(includeMetadataChanges: true);
  }

  Future<String> deleteAllNotification(String uid) {
    try {
      return _firestore.collection('users').doc(uid).update({
        'listaNotifiche': [],
        'newNotifiche': false,
      }).then((value) {
        return 'ok';
      });
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  Future<void> updateNotificationRead(
      String notificationId, String userId, newNotification) async {
    try {
      await _firestore.collection('users').doc(userId).get().then((value) {
        List<dynamic> notifications = value.data()!['listaNotifiche'];
        int index = notifications.indexWhere(
            (element) => element['notificationId'] == notificationId);
        notifications[index] = newNotification;

        bool hasUnreadNotifications =
            notifications.any((notification) => !notification['read']);

        _firestore.collection('users').doc(userId).update({
          'listaNotifiche': notifications,
          'newNotifiche': hasUnreadNotifications,
        });
      });
    } on FirebaseException catch (e) {
      return Future.error(NotificationFailure(e.code));
    } catch (e) {
      return Future.error(NotificationFailure(e.toString()));
    }
  }

  Future<void> deleteNotificationById(
      String notificationId, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).get().then((value) {
        List<dynamic> notifications = value.data()!['listaNotifiche'];
        notifications.removeWhere(
            (element) => element['notificationId'] == notificationId);
        _firestore.collection('users').doc(userId).update({
          'listaNotifiche': notifications,
        });
      });
    } on FirebaseException catch (e) {
      return Future.error(NotificationFailure(e.code));
    } catch (e) {
      return Future.error(NotificationFailure(e.toString()));
    }
  }

  /// add notification to the user
  Future<void> addNotificationToUser(
      String userId, Map<String, dynamic> notification) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'listaNotifiche': FieldValue.arrayUnion([notification]),
        'newNotifiche': true,
      });
    } on FirebaseException catch (e) {
      return Future.error(NotificationFailure(e.code));
    } catch (e) {
      return Future.error(NotificationFailure(e.toString()));
    }
  }

  Future<void> setAllNotificationRead(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).get().then((value) {
        List<dynamic> notifications = value.data()!['listaNotifiche'];
        for (var i = 0; i < notifications.length; i++) {
          notifications[i]['isRead'] = true;
        }
        _firestore.collection('users').doc(userId).update({
          'listaNotifiche': notifications,
          'newNotifiche': false,
        });
      });
    } on FirebaseException catch (e) {
      return Future.error(NotificationFailure(e.code));
    } catch (e) {
      return Future.error(NotificationFailure(e.toString()));
    }
  }

  /// Calculate the average rating of a recipe
  Future<void> calculateAverageRating(String recipeId) async {
    try {
      num media = 0;
      await _firestore.collection('recipes').doc(recipeId).get().then(
        (value) async {
          if (value.data()!['numero_commenti'] == 0) {
            return;
          }
          for (var commenti in value.data()!['commenti']) {
            if (commenti['numeroStelle'] != null) {
              media = media + commenti['numeroStelle'];
            }
          }
          media = media ~/ value.data()!['numero_commenti'];
          print(media);
          await _firestore.collection('recipes').doc(recipeId).update({
            'media_recensioni': media,
          });
        },
      );
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  Future<String> addGamingToUser(String userId, Gaming gaming) async {
    try {
      String res = 'error';
      await _firestore.collection('users').doc(userId).update({
        'gaming': gaming.toMap(),
        'gameActive': true,
      }).then((value) async {
        res = 'ok';
      });
      return res;
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Get gaming data from user
  Future<Gaming> getGamingData(String userId) async {
    try {
      Gaming gaming = Gaming.empty();
      await _firestore.collection('users').doc(userId).get().then((value) {
        gaming = Gaming.fromMap(value.data()!['gaming']);
      });
      return gaming;
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// Update user gaming data
  Future<void> updateGamingData(String userId, Gaming gaming) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'gaming': gaming.toMap(),
      });
    } on FirebaseException catch (e) {
      return Future.error(GameingFailure(e.code));
    } catch (e) {
      return Future.error(GameingFailure(e.toString()));
    }
  }

  /// Add a challenge to the database.
  Future<String> addSfida(Sfidegame sfida) async {
    try {
      if (sfida.type == SfideType.none) {
        return 'error';
      }
      if (sfida.type == SfideType.ingredients &&
          sfida.ingredienti!.isNotEmpty) {
        await _firestore.collection('sfide').add(sfida.toMap()).then((value) {
          return "ok";
        });
      }
      if (sfida.type == SfideType.image && sfida.immagini!.isNotEmpty) {
        await _storage
            .uploadMultipleFiles("sfide/${sfida.id}", sfida.immagini!)
            .then(
          (value) async {
            sfida = sfida.copyWith(urlImmagini: value, immagini: []);
            print(sfida.toMap());
            await _firestore.collection('sfide').add(sfida.toMap()).then(
              (value) {
                return "ok";
              },
            );
          },
        );
      }
      return 'error';
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  /// get current challenge
  Future<Sfidegame> getCurrentSfida() {
    try {
      return _firestore
          .collection('sfide')
          .where("dataFine", isGreaterThanOrEqualTo: DateTime.now())
          .where("dataInizio", isLessThanOrEqualTo: DateTime.now())
          .orderBy('dataInizio', descending: false)
          .get()
          .then((value) {
        return Sfidegame.fromMap(value.docs[0].data());
      });
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  /// get next challenge
  Future<List<Sfidegame>> getNextChallenge() {
    try {
      return _firestore
          .collection('sfide')
          .where("dataInizio", isGreaterThan: DateTime.now())
          .orderBy('dataInizio', descending: false)
          .get()
          .then((value) {
        List<Sfidegame> sfide = [];
        for (var sfida in value.docs) {
          sfide.add(Sfidegame.fromMap(sfida.data()));
        }
        return sfide;
      });
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  /// Add point to winner user
  Future<void> addPointToWinner(Sfidegame game) async {
    try {
      String docID = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: game.id)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      String userId = await _firestore
          .collection('sfide')
          .doc(docID)
          .collection('recipes')
          .doc(game.classifica.first)
          .get()
          .then((value) {
        return value.data()!['userID'];
      });

      // aggiungi i punti all utente
      await _firestore.collection('users').doc(userId).get().then((value) {
        Gaming gaming = Gaming.fromMap(value.data()!['gaming']);
        gaming = gaming.copyWith(
          punti: gaming.punti + 500,
          gameName: checkUserName(gaming.copyWith(punti: gaming.punti + 500)),
          sfideVinte: gaming.sfideVinte + 1,
        );
        _firestore.collection('users').doc(userId).update({
          'gaming': gaming.toMap(),
        });
      });
    } on FirebaseException catch (e) {
      return Future.error(AddPointerFailure(e.code));
    } catch (e) {
      return Future.error(AddPointerFailure(e.toString()));
    }
  }

  /// get old challenge
  Future<List<Sfidegame>> getOldChallenge() async {
    try {
      return _firestore
          .collection('sfide')
          .where("dataFine", isLessThan: DateTime.now())
          .orderBy('dataInizio', descending: false)
          .get()
          .then((value) async {
        List<Sfidegame> sfide = [];
        for (var sfida in value.docs) {
          Sfidegame tempSfida = Sfidegame.fromMap(sfida.data());

          sfide.add(tempSfida);

          if (tempSfida.old == false) {
            await addPointToWinner(tempSfida);

            await _firestore.collection('sfide').doc(sfida.id).update({
              'old': true,
            });
          }
        }
        return sfide;
      });
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  /// get nickname from string
  Future<String> getNickname(String uid) async {
    try {
      return _firestore.collection('users').doc(uid).get().then((value) {
        return value.data()!['nickname'];
      });
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }

  /// iscrivi user alla sfida
  Future<String> iscriviUserSfida(String uid, String sfidaId) async {
    try {
      await _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfidaId)
          .get()
          .then((value) async {
        await _firestore.collection('sfide').doc(value.docs[0].id).update({
          'utentiPartecipanti': FieldValue.arrayUnion([uid]),
          'partecipanti': FieldValue.increment(1),
        });
      });

      await _firestore.collection('users').doc(uid).update({
        'gaming.sfide': FieldValue.arrayUnion([sfidaId]),
        'gaming.sfidePartecipate': FieldValue.increment(1),
      });

      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  /// get sfida by id
  Future<Sfidegame> getSfidaById(String sfidaId) async {
    try {
      return _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfidaId)
          .get()
          .then((value) {
        return Sfidegame.fromMap(value.docs[0].data());
      });
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  /// get sfida by id
  Future<String> updateSfida(Sfidegame sfida) async {
    try {
      if (sfida.type == SfideType.none) {
        return 'error';
      }
      if (sfida.type == SfideType.ingredients &&
          sfida.ingredienti!.isNotEmpty) {
        await _firestore
            .collection('sfide')
            .doc(sfida.id)
            .update(sfida.toMap());
      }
      if (sfida.type == SfideType.image && sfida.immagini!.isNotEmpty) {
        await _storage
            .uploadMultipleFiles("sfide/${sfida.id}", sfida.immagini!)
            .then(
          (value) async {
            sfida = sfida.copyWith(urlImmagini: value, immagini: []);
            await _firestore
                .collection('sfide')
                .doc(sfida.id)
                .update(sfida.toMap());
          },
        );
      }
      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  Future<String> addRecipeSfida(
      AuthUser oldUser, RecipesState state, String uid, String sfidaId) async {
    try {
      String coverImageUrl = await _storage.uploadFile(
          'cover_images_sfida/$sfidaId/$uid',
          state.coverImage!,
          "${sfidaId}cover");
      List<String> stepImagesUrl = await _storage.uploadMultipleFiles(
          'step_images_sfida/$sfidaId/$uid', state.immagini);

      final Recipesfide recipe = Recipesfide(
          recipeID: uid,
          sfidaID: sfidaId,
          userID: oldUser.uid,
          nomePiatto: state.nomePiatto!,
          descrizione: state.descrizione!,
          coverImage: coverImageUrl,
          tempoPreparazione: state.tempoPreparazione!,
          porzioni: state.porzioni!,
          difficolta: state.difficolta!,
          ingredienti: state.ingredienti,
          tag: state.tag,
          allergie: state.allergie,
          immaginiPassaggi: stepImagesUrl,
          passaggi: state.passaggi,
          visualizzazioni: [],
          votiNegativi: [],
          votiPositivi: []);

      String docId = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfidaId)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      print(docId);

      await _firestore
          .collection("sfide")
          .doc(docId)
          .collection("recipes")
          .doc(uid)
          .set(recipe.toMap());

      await _firestore.collection('sfide').doc(docId).update({
        'ricettePubblicate': FieldValue.arrayUnion([uid]),
        'classifica': FieldValue.arrayUnion([uid]),
      });

      return 'ok';
    } on FirebaseException catch (e) {
      return Future.error(AddChallengeFailure(e.code));
    } catch (e) {
      return Future.error(AddChallengeFailure(e.toString()));
    }
  }

  /// Get user recipe of challenge
  Future<Recipesfide> getUserSfideRecipe(String sfidaId, String uid) async {
    try {
      Recipesfide recipe = Recipesfide.empty();

      String docID = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfidaId)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      DocumentReference docRef = _firestore.collection("sfide").doc(docID);

      await docRef.collection("recipes").get().then((value) {
        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            if (doc.data()['userID'] == uid) {
              recipe = Recipesfide.fromSnapshot(doc.data());
            }
          }
        } else {
          return Future.error(
              const GetRecipeFailure('Nessuna ricetta pubblicata'));
        }
      });
      if (recipe.recipeID != '') {
        return recipe;
      } else {
        return Future.error(
            const GetRecipeFailure('Nessuna ricetta pubblicata'));
      }
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  /// Get all the recipes of a challenge
  Future<List<Recipesfide>> getRicettePubbllicateSfida(
      String sfidaId, String userId) async {
    try {
      String docID = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfidaId)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      List<Recipesfide> recipes = [];
      await _firestore
          .collection('sfide')
          .doc(docID)
          .collection('recipes')
          .get()
          .then((value) {
        for (var doc in value.docs) {
          recipes.add(Recipesfide.fromSnapshot(doc.data()));
        }
      });

      return recipes;
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  /// Aggiungi una visualizzazione alla ricetta
  Future<void> addViewToRecipe(
      String recipeID, String sfidaID, String userID) async {
    try {
      String docID = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfidaID)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      // controllo se l'utenete ha già visualizzato la ricetta
      await _firestore
          .collection('sfide')
          .doc(docID)
          .collection("recipes")
          .doc(recipeID)
          .get()
          .then((value) {
        if (value.exists) {
          if (value.data()!['visualizzazioni'].contains(userID)) {
            List<String> unique =
                Set<String>.from(value.data()!['visualizzazioni']).toList();
            if (unique.length == value.data()!['visualizzazioni'].length) {
              return;
            }

            _firestore
                .collection('sfide')
                .doc(docID)
                .collection("recipes")
                .doc(recipeID)
                .update({
              'visualizzazioni': unique,
            });

            return;
          }
          _firestore
              .collection('sfide')
              .doc(docID)
              .collection("recipes")
              .doc(recipeID)
              .update({
            'visualizzazioni': FieldValue.arrayUnion([userID]),
          });
        }
      });
    } on FirebaseException catch (e) {
      return Future.error(AddRecipeViewFailure(e.code));
    } catch (e) {
      return Future.error(AddRecipeViewFailure(e.toString()));
    }
  }

  /// Aggiorna ricetta
  Future<void> updateRecipeSfide(Recipesfide recipe) async {
    try {
      String docID = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: recipe.sfidaID)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      await _firestore
          .collection('sfide')
          .doc(docID)
          .collection("recipes")
          .doc(recipe.recipeID)
          .update(recipe.toMap());

      List<String> classifica = await updateClassifica(recipe.sfidaID);

      await _firestore.collection('sfide').doc(docID).update({
        'classifica': classifica,
      });
    } on FirebaseException catch (e) {
      return Future.error(AddRecipeViewFailure(e.code));
    } catch (e) {
      return Future.error(AddRecipeViewFailure(e.toString()));
    }
  }

  /// Update classifica of the challenge
  Future<List<String>> updateClassifica(String sfidaId) async {
    try {
      List<String> classifica = [];
      List<Recipesfide> recipes = [];

      await getRicetteClassificaSfida(sfidaId).then((value) {
        recipes = value;
      });

      // Calcola il punteggio per ogni ricetta
      for (Recipesfide ricetta in recipes) {
        int score = ricetta.visualizzazioni.length +
            (2 * ricetta.votiPositivi.length) -
            ricetta.votiNegativi.length;
        ricetta.copyWith(score: score);
      }

      // Ordina le ricette in base al punteggio
      recipes.sort((a, b) => b.score.compareTo(a.score));

      // Aggiorna la classifica
      classifica = recipes.map((ricetta) => ricetta.recipeID).toList();

      return classifica;
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  /// Get all the recipes of a challenge
  Future<List<Recipesfide>> getRicetteClassificaSfida(String sfidaId) async {
    try {
      String docID = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfidaId)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      List<Recipesfide> recipes = [];
      await _firestore
          .collection('sfide')
          .doc(docID)
          .collection('recipes')
          .get()
          .then((value) {
        for (var doc in value.docs) {
          recipes.add(Recipesfide.fromSnapshot(doc.data()));
        }
      });
      return recipes;
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  Future<int> getPosizioneInClassifica(Recipesfide recipe) async {
    try {
      List<Recipesfide> recipes = [];
      await getRicetteClassificaSfida(recipe.sfidaID).then((value) {
        recipes = value;
      });

      for (var i = 0; i < recipes.length; i++) {
        if (recipes[i].recipeID == recipe.recipeID) {
          return i + 1;
        }
      }
      return 0;
    } on FirebaseException catch (e) {
      return Future.error(GetRecipeFailure(e.code));
    } catch (e) {
      return Future.error(GetRecipeFailure(e.toString()));
    }
  }

  Future<String> getNicknameFromSfida(Sfidegame sfida) async {
    try {
      String docID = await _firestore
          .collection('sfide')
          .where('id', isEqualTo: sfida.id)
          .get()
          .then((value) {
        return value.docs[0].id;
      });

      String userId = await _firestore
          .collection('sfide')
          .doc(docID)
          .collection('recipes')
          .doc(sfida.classifica.first)
          .get()
          .then((value) {
        return value.data()!['userID'];
      });

      return getNickname(userId);
    } on FirebaseException catch (e) {
      return Future.error(UpdateProfileFailure(e.code));
    } catch (e) {
      return Future.error(UpdateProfileFailure(e.toString()));
    }
  }
}
