// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/model/Comment.dart';
import 'package:condivisionericette/screens/recipes/view_screen/controller/recipe_interaction_controller.dart';
import 'package:condivisionericette/utils/constant.dart';

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
    if (value.isEmpty) {
      state = state.copyWith(
          errorMessage: "Il nome del piatto non può essere vuoto",
          errorType: ErrorType.nomePiatto);
    } else {
      state = state.copyWith(nomePiatto: value);
    }
  }

  void onIngredientiSfidaChanged(List<String> value) {
    state = state.copyWith(ingredienti: value);
  }

  void onDescrizioneChanged(String value) {
    if (value.isEmpty) {
      state = state.copyWith(
          errorMessage: "La descrizione non può essere vuota",
          errorType: ErrorType.descrizione);
    } else {
      state = state.copyWith(descrizione: value);
    }
  }

  void onTempoPreparazioneChanged(int value) {
    if (value == 0 || value.isNegative) {
      state = state.copyWith(
        errorType: ErrorType.tempoPreparazione,
        errorMessage: "Il tempo di preparazione non può essere 0",
      );
    } else {
      state = state.copyWith(tempoPreparazione: value);
    }
  }

  void onPorzioniChanged(int value) {
    if (value == 0 || value.isNegative) {
      state = state.copyWith(
        errorType: ErrorType.porzioni,
        errorMessage: "Le porzioni non possono essere 0",
      );
    } else {
      state = state.copyWith(porzioni: value);
    }
  }

  void onDifficoltaChanged(String value) {
    if (value.isEmpty ||
        value == "Difficoltà" ||
        value == "Seleziona la difficoltà") {
      state = state.copyWith(
        errorType: ErrorType.difficolta,
        errorMessage: "La difficoltà non può essere vuota",
      );
    } else if (value.toLowerCase().trim() != "facile" &&
        value.trim().toLowerCase() != "media" &&
        value.trim().toLowerCase() != "difficile") {
      state = state.copyWith(
        errorType: ErrorType.difficolta,
        errorMessage: "La difficoltà deve essere Facile, Media o Difficile",
      );
    } else {
      state = state.copyWith(difficolta: value);
    }
  }

  void onIngredientiChanged(String value) {
    if (value.isEmpty) {
      state = state.copyWith(
        errorMessage: "L'ingrediente non può essere vuoto",
        errorType: ErrorType.ingredienti,
      );
    } else {
      state = state.copyWith(ingrediente: value);
    }
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
    String ingrediente = "${state.ingrediente!} ${state.quantita!} $misura";
    state = state.copyWith(ingredienti: [...state.ingredienti, ingrediente]);
  }

  void removeIngredienti(String value) {
    state = state.copyWith(
        ingredienti: state.ingredienti.where((e) => e != value).toList());
  }

  void onTagChanged(String value) {
    if (value.isEmpty) {
      state = state.copyWith(
        errorMessage: "Il tag non può essere vuoto",
        errorType: ErrorType.tag,
      );
    } else {
      state = state.copyWith(tagSingolo: value);
    }
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
    if (value.isEmpty) {
      state = state.copyWith(
        errorMessage: "L'allergia non può essere vuota",
        errorType: ErrorType.allergie,
      );
    } else {
      state = state.copyWith(allergia: value);
    }
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
    if (value.isEmpty) {
      state = state.copyWith(
        errorMessage: "La misura non può essere vuota",
        errorType: ErrorType.ingredienti,
      );
    }
    state = state.copyWith(misura: value);
  }

  void onQuantitaChanged(String value) {
    if (value.isEmpty) {
      state = state.copyWith(
        errorMessage: "La quantità non può essere vuota",
        errorType: ErrorType.ingredienti,
      );
    }
    state = state.copyWith(quantita: value);
  }

  void onCoverImageChanged(Uint8List value) {
    state = state.copyWith(coverImage: value);
  }

  void onStepIndexChanged(int value) {
    state = state.copyWith(stepIndex: value);
  }

  void resetError() {
    state = state.copyWith(
      errorMessage: '',
      errorType: ErrorType.nessuno,
      status: StateRecipes.initial,
    );
  }

  String addStep() {
    if (state.stepImage == null) {
      state = state.copyWith(
        errorMessage: "Lo step deve avere un'immagine",
        errorType: ErrorType.stepImage,
      );
    }

    if (state.stepText == null || state.stepText!.isEmpty) {
      state = state.copyWith(
        errorMessage: "Lo step deve avere una descrizione",
        errorType: ErrorType.stepText,
      );
    }

    if (state.stepImage != null && state.stepText != null) {
      state = state.copyWith(
        passaggi: [...state.passaggi, state.stepText!],
        immagini: [...state.immagini, state.stepImage!],
        stepIndex: state.stepIndex! + 1,
      );
    }

    return 'ok';
  }

  void removeStep(int value) {
    List<String> passaggi = state.passaggi;
    List<Uint8List> immagini = state.immagini;

    passaggi.removeAt(value);
    immagini.removeAt(value);

    state = state.copyWith(
      passaggi: passaggi,
      immagini: immagini,
      stepIndex: state.stepIndex! - 1,
    );
  }

  void addStepImage(Uint8List value) {
    state = state.copyWith(stepImage: value);
  }

  void addStepText(String value) {
    state = state.copyWith(stepText: value);
  }

  Future<String> addRecipes(AuthUser oldUser, bool sfida, String sfidaId,
      List<String> ingredienti) async {
    try {
      if (state.errorType != ErrorType.nessuno) {
        state = state.copyWith(status: StateRecipes.error);
        return "error";
      }

      if (state.coverImage == null) {
        state = state.copyWith(
          errorMessage: "Il piatto deve avere una cover image",
          errorType: ErrorType.coverImage,
        );
        state = state.copyWith(status: StateRecipes.error);
        return "error";
      }

      if (state.stepImage == null || state.passaggi.isEmpty) {
        state = state.copyWith(
          errorMessage: "Lo step deve avere un'immagine e una descrizione",
          errorType: ErrorType.stepImage,
        );
        state = state.copyWith(status: StateRecipes.error);
        return "error";
      }

      if (state.allergie.isEmpty) {
        state = state.copyWith(
          allergie: ["nessuna"],
        );
      }

      if (state.tag.isEmpty) {
        state = state.copyWith(
          tag: ["nessun tag"],
        );
      }

      if (state.ingredienti.isEmpty && !sfida) {
        state = state.copyWith(
          errorMessage: "Inserisci almeno un ingrediente",
          errorType: ErrorType.ingredienti,
        );
        state = state.copyWith(status: StateRecipes.error);
        return "error";
      }

      state = state.copyWith(status: StateRecipes.inProgress);
      if (!sfida) {
        _firebaseRepo.addRecipe(
          oldUser,
          state,
          const Uuid().v4(),
        );
      } else if (sfida) {
        state = state.copyWith(ingredienti: ingredienti);
        _firebaseRepo.addRecipeSfida(
          oldUser,
          state,
          const Uuid().v4(),
          sfidaId,
        );
      }
      state = state.copyWith(status: StateRecipes.done);

      return "ok";
    } catch (e) {
      print(e);
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

  void onEditStep(bool value, int index) {
    state = state.copyWith(editStep: value, editIndex: index);
  }

  void onEditStepText(String value) {
    state = state.copyWith(stepText: value);

    List<String> passaggi = state.passaggi;

    passaggi[state.editIndex!] = value;
    state = state.copyWith(passaggi: passaggi, newDescription: "");
  }

  void onEditImage(Uint8List value) {
    state = state.copyWith(newStepImage: value);

    List<Uint8List> immagini = state.immagini;

    immagini[state.editIndex!] = value;
    state = state.copyWith(immagini: immagini, newStepImage: null);
  }

  void clearStep() {
    state = state.copyWith(
      stepText: null,
      stepImage: Uint8List(0),
      editStep: false,
      editIndex: null,
    );
    print(state.stepText);
  }
}
