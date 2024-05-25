import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/model/Comment.dart';
import 'package:condivisionericette/screens/recipes/view_screen/controller/recipe_interaction_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

part 'recipes_state.dart';

final addRecipesProvider =
    StateNotifierProvider.autoDispose<AddRecipesController, RecipesState>(
        (ref) => AddRecipesController(
            ref.watch(authRepoProvider), ref.watch(firebaseRepoProvider)));

class AddRecipesController extends StateNotifier<RecipesState> {
  final AuthenticationRepository _authRepo;
  final FirebaseRepository _firebaseRepo;

  AddRecipesController(this._authRepo, this._firebaseRepo)
      : super(const RecipesState());

  void onNomePiattoChanged(String value) {
    state = state.copyWith(nomePiatto: value);
  }

  void onDescrizioneChanged(String value) {
    state = state.copyWith(descrizione: value);
  }

  void onTempoPreparazioneChanged(int value) {
    state = state.copyWith(tempoPreparazione: value);
  }

  void onPorzioniChanged(int value) {
    state = state.copyWith(porzioni: value);
  }

  void onDifficoltaChanged(String value) {
    state = state.copyWith(difficolta: value);
  }

  void onIngredientiChanged(String value) {
    state = state.copyWith(ingrediente: value);
  }

  void addIngredienti() {
    String misura = state.misura!;
    switch (state.misura!) {
      case "grammi":
        misura = "g";
        break;
      case "millilitri":
        misura = "ml";
        break;
      case "litri":
        misura = "l";
        break;
      case "chilogrammi":
        misura = "kg";
        break;
    }
    String ingrediente =
        state.ingrediente! + " " + state.quantita! + " " + misura;
    state = state.copyWith(ingredienti: [...state.ingredienti, ingrediente]);
  }

  void removeIngredienti(String value) {
    state = state.copyWith(
        ingredienti: state.ingredienti.where((e) => e != value).toList());
  }

  void onTagChanged(String value) {
    state = state.copyWith(tagSingolo: value);
  }

  void addTag() {
    state = state.copyWith(tag: [...state.tag, state.tagSingolo!]);
  }

  void removeTag(String value) {
    state = state.copyWith(tag: state.tag.where((e) => e != value).toList());
  }

  void onPassaggiChanged(List<String> value) {
    state = state.copyWith(passaggi: value);
  }

  void onAllergieChanged(String value) {
    state = state.copyWith(allergia: value);
  }

  void addAllergie() {
    state = state.copyWith(allergie: [...state.allergie, state.allergia!]);
  }

  void removeAllergie(String value) {
    state = state.copyWith(
        allergie: state.allergie.where((e) => e != value).toList());
  }

  void onImmaginiChanged(List<Uint8List> value) {
    state = state.copyWith(immagini: value);
  }

  void onMisuraChanged(String value) {
    state = state.copyWith(misura: value);
  }

  void onQuantitaChanged(String value) {
    state = state.copyWith(quantita: value);
  }

  void onCoverImageChanged(Uint8List value) {
    state = state.copyWith(coverImage: value);
  }

  void onStepIndexChanged(int value) {
    state = state.copyWith(stepIndex: value);
  }

  void addStep() {
    if (state.stepImage != null && state.stepText != null) {
      state = state.copyWith(
        passaggi: [...state.passaggi, state.stepText!],
        immagini: [...state.immagini, state.stepImage!],
        stepIndex: state.stepIndex! + 1,
      );
    }
  }

  void removeStep(int value) {
    state = state.copyWith(
      passaggi:
          state.passaggi.where((e) => e != state.passaggi[value]).toList(),
      immagini:
          state.immagini.where((e) => e != state.immagini[value]).toList(),
      stepIndex: state.stepIndex! - 1,
    );
  }

  void addStepImage(Uint8List value) {
    state = state.copyWith(stepImage: value);
  }

  void addStepText(String value) {
    state = state.copyWith(stepText: value);
  }

  Future<String> addRecipes(AuthUser oldUser) async {
    try {
      state = state.copyWith(status: StateRecipes.inProgress);
      _firebaseRepo.addRecipe(
        oldUser,
        state,
        const Uuid().v4(),
      );
      state = state.copyWith(status: StateRecipes.done);

      return "ok";
    } catch (e) {
      state = state.copyWith(status: StateRecipes.error);
      return "error";
    }
  }

  Future<void> addMultiNotification(
      List<Map<String, dynamic>> notificheDaInviare, List<String> list) async {
    try {
      for (var index = 0; index < list.length; index++) {
        await _firebaseRepo.addNotificationToUser(
            list[index], notificheDaInviare[index]);
      }
    } catch (e) {
      print(e);
    }
  }
}
