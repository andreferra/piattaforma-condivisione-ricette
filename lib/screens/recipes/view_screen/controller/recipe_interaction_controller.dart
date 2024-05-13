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
      : super(const RecipeInteraction());

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

  void onCommentSubmitted() {
    final comment = state.commento;
    if (comment != null) {
      state = state.copyWith(
        commenti: [...state.commenti!, comment.idCommento!],
        numeroCommenti: state.numeroCommenti! + 1,
        commento: null,
      );
    }
  }
}
