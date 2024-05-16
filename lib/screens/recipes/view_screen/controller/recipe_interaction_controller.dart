import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/model/Comment.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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

  void onCommentTextChanged(String value, AuthUser user) {
    state = state.copyWith(
      commento: Comment(
        commento: value,
        dataCreazione: Timestamp.now(),
        nicknameUtente: user.nickname,
        urlUtente: user.photoURL,
        userId: user.uid,
        idCommento: const Uuid().v4(),
      ),
    );
  }

  Future<String> onCommentSubmitted(String recipeId) async {
    try {
      final comment = state.commento;
      if (comment != null) {
        if (comment.numeroStelle != state.numeroStelle) {
          comment.copyWith(
            numeroStelle: state.numeroStelle,
          );
        }
        await _firebaseRepo.addComment(comment.toMap(), recipeId);
        state = state.copyWith(
          commenti: [...state.commenti!, comment],
          commento: Comment.empty,
        );
        return "ok";
      }
      return "error";
    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future<String> addOnReply(String recipeId) async {
    try {
      final comment = state.commento;
      if (comment != null) {
        await _firebaseRepo.addReply(
            comment.toMap(), recipeId, state.idCommentoReply!);
        state = state.copyWith(
          commenti: [...state.commenti!, comment],
          commento: Comment.empty,
        );
        return "ok";
      }
      return "error";
    } catch (e) {
      print(e);
      return "error";
    }
  }

  onReplyComment(String idCommento) {
    state = state.copyWith(
      reply: !state.reply!,
      idCommentoReply: idCommento,
    );
  }

  onSetStars(int stars) {
    state = state.copyWith(
      numeroStelle: stars,
    );
  }
}
