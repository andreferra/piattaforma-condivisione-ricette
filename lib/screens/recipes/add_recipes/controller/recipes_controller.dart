import 'dart:typed_data';

import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    String ingrediente = state.ingrediente! + " " + state.quantita! + " " + misura;
    state = state.copyWith(ingredienti: [...state.ingredienti, ingrediente]);
  }

  void removeIngredienti(String value) {
    state = state.copyWith(ingredienti: state.ingredienti.where((e) => e != value).toList());
  }

  void onTagChanged(List<String> value) {
    state = state.copyWith(tag: value);
  }

  void onPassaggiChanged(List<String> value) {
    state = state.copyWith(passaggi: value);
  }

  void onAllergieChanged(List<String> value) {
    state = state.copyWith(allergie: value);
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


}
