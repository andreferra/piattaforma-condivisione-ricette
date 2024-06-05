// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_repo/model_repo.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/model/Comment.dart';

part 'recipe_interaction_state.dart';

final recipeInteractionProvider = StateNotifierProvider.autoDispose<
        RecipeInteractionController, RecipeInteraction>(
    (ref) => RecipeInteractionController(
        ref.watch(firebaseRepoProvider), ref.watch(authRepoProvider)));

class RecipeInteractionController extends StateNotifier<RecipeInteraction> {
  final AuthenticationRepository _authRepo;
  final FirebaseRepository _firebaseRepo;

  RecipeInteractionController(this._firebaseRepo, this._authRepo)
      : super(RecipeInteraction());

  void onImageAdded(Uint8List image) {
    if (state.imageFile!.length < 4) {
      state = state.copyWith(
        imageFile: [...state.imageFile!, image],
      );
    }
  }

  void onCommentTextChanged(String value, AuthUser user) {
    if (state.commento == null) {
      state = state.copyWith(
        commento: Comment(
          commento: value,
          dataCreazione: Timestamp.now(),
          nicknameUtente: user.nickname,
          urlUtente: user.photoURL,
          userId: user.uid,
          idCommento: const Uuid().v4(),
          numeroStelle: state.numeroStelle ?? 1,
        ),
      );
    } else {
      state = state.copyWith(
        commento: state.commento!.copyWith(
          commento: value,
        ),
      );
    }
  }

  Future<void> updateGamingProfile(
      String id, Gaming gaming, bool isMine) async {
    try {
      //se l'ho pubblicato io sono 25 punti altrimenti 50
      gaming = gaming.copyWith(
        punti: gaming.punti + (isMine ? 50 : 25),
        gameName: _firebaseRepo.checkUserName(gaming),
      );

      await _firebaseRepo.updateGamingData(id, gaming);
    } catch (e) {
      print(e);
    }
  }

  Future<String> onCommentSubmitted(String recipeId) async {
    try {
      var comment = state.commento;
      state = state.copyWith(uploadComment: UploadComment.loading);

      if (comment != null) {
        if (comment.commento!.isEmpty) {
          return "error";
        }

        if (state.imageFile!.isNotEmpty) {
          List<String> imageUrl = [];
          imageUrl = await _firebaseRepo.uploadImageComment(
              recipeId, comment.idCommento!, state.imageFile!);

          comment = comment.addImageLink(imageUrl);
        }

        await _firebaseRepo.addComment(comment.toMap(), recipeId);
        state = state.copyWith(
          commenti: [...state.commenti!, comment],
          commento: null,
          reply: false,
          numeroStelle: 1,
          imageFile: [],
          uploadComment: UploadComment.loaded,
        );
        return "ok";
      }
      state = state.copyWith(
        uploadComment: UploadComment.error,
        errorMex: "Errore",
      );
      return "error";
    } catch (e) {
      state = state.copyWith(
        uploadComment: UploadComment.error,
        errorMex: e.toString(),
      );
      return "error";
    }
  }

  Future<String> addOnReply(String recipeId) async {
    try {
      String res = "error";
      final comment = state.commento;
      state = state.copyWith(uploadComment: UploadComment.loading);

      if (comment != null) {
        if (state.commento!.idCommento!.isEmpty) {
          return "error";
        }

        await _firebaseRepo
            .addReply(comment.toMap(), recipeId, state.idCommentoReply!)
            .then((value) {
          switch (value) {
            case "ok":
              state = state.copyWith(
                commenti: state.commenti!
                    .map((e) => e.idCommento == state.idCommentoReply
                        ? e.copyWith(
                            risposte: [...e.risposte!, comment],
                          )
                        : e)
                    .toList(),
                commento: null,
                numeroStelle: 1,
                reply: false,
                imageFile: [],
                uploadComment: UploadComment.loaded,
              );
              res = "ok";
              break;
            default:
              state = state.copyWith(
                uploadComment: UploadComment.error,
                errorMex: value,
              );
              res = "error";
              break;
          }
        });
      }
      return res;
    } catch (e) {
      state = state.copyWith(
          uploadComment: UploadComment.error, errorMex: e.toString());
      return "error";
    }
  }

  onReplyComment(String idCommento) {
    state = state.copyWith(
      reply: !state.reply!,
      idCommentoReply: idCommento,
    );
  }

  onSetStars(int stars, AuthUser user) {
    if (state.commento == null) {
      state = state.copyWith(
        commento: Comment(
          commento: "",
          dataCreazione: Timestamp.now(),
          nicknameUtente: user.nickname,
          urlUtente: user.photoURL,
          userId: user.uid,
          idCommento: const Uuid().v4(),
          numeroStelle: state.numeroStelle ?? 1,
        ),
        numeroStelle: stars,
      );
    }

    state = state.copyWith(
      commento: state.commento!.copyWith(
        numeroStelle: stars,
      ),
      numeroStelle: stars,
    );
  }

  Future<String> onDeleteComment(String idCommento, String idRicetta) async {
    try {
      String res = "error";
      await _firebaseRepo.deleteComment(idRicetta, idCommento).then((value) {
        switch (value) {
          case "ok":
            state = state.copyWith(
              commenti: state.commenti!
                  .where((element) => element.idCommento != idCommento)
                  .toList(),
            );
            res = "ok";
            break;
          default:
            res = "error";
            break;
        }
      });
      return res;
    } catch (e) {
      print(e);
      return "error";
    }
  }
}
