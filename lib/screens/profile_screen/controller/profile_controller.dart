// Dart imports:
import 'dart:typed_data';

// Project imports:
import 'package:condivisionericette/controller/auth_repo_provider.dart';
// Package imports:
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';
import 'package:universal_html/html.dart' as html;

part "profile_state.dart";

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileState>((ref) =>
        ProfileController(
            ref.watch(authRepoProvider), ref.watch(firebaseRepoProvider)));

class ProfileController extends StateNotifier<ProfileState> {
  final AuthenticationRepository _authRepo;
  final FirebaseRepository _firebaseRepo;

  ProfileController(this._authRepo, this._firebaseRepo)
      : super(const ProfileState());

  void onNewPhotoUrlChanged(String value) {
    state = state.copyWith(newPhotoUrl: value);
  }

  void onNewNicknameChanged(String value) {
    final nickname = Nickname.dirty(value);
    state = state.copyWith(
      newNickname: nickname,
      status: Formz.validate([nickname, state.newBio!]),
    );
  }

  void checkPrefAlimentare(String prefAlimentare) {
    final prefAlimentari = PreferenzeAlimentari.dirty(prefAlimentare);
    state = state.copyWith(
        alimentoPreferito: prefAlimentari,
        status: Formz.validate([prefAlimentari]));
  }

  void checkAllergeno(String allergene) {
    final allergeno = Allergeni.dirty(allergene);
    state = state.copyWith(
        allergeno: allergeno, status: Formz.validate([allergeno]));
  }

  void checkInteresseCulinario(String interesse) {
    final interesseCulinario = InteressiCulinari.dirty(interesse);
    state = state.copyWith(
        interesseCulinario: interesseCulinario,
        status: Formz.validate([interesseCulinario]));
  }

  void onNewAllergenoChanged(String value, List<String> allergie) {
    try {
      final allergeno = Allergeni.dirty(value);

      if (allergeno.valid && !allergie.contains(allergeno.value.toString())) {
        allergie.add(allergeno.value.toString());
      }
      state = state.copyWith(
          allergeno: const Allergeni.pure(),
          allergie: allergie,
          status: Formz.validate([allergeno]));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onNewInteresseCulinarioChanged(String value, List<String> interessi) {
    try {
      final interesseCulinario = InteressiCulinari.dirty(value);

      if (interesseCulinario.valid &&
          !interessi.contains(interesseCulinario.value.toString())) {
        interessi.add(interesseCulinario.value.toString());
      }
      state = state.copyWith(
          interesseCulinario: const InteressiCulinari.pure(),
          interessiCulinari: interessi,
          status: Formz.validate([interesseCulinario]));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onNewPrefAlimentareChanged(String value, List<String> preferenze) {
    try {
      final prefAlimentare = PreferenzeAlimentari.dirty(value);

      if (prefAlimentare.valid &&
          !preferenze.contains(prefAlimentare.value.toString())) {
        preferenze.add(prefAlimentare.value.toString());
      }
      state = state.copyWith(
          alimentoPreferito: const PreferenzeAlimentari.pure(),
          prefAlimentari: preferenze,
          status: Formz.validate([prefAlimentare]));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void removePrefAlimentare(String prefAlimentare, List<String> preferenze) {
    preferenze.remove(prefAlimentare);
    state = state.copyWith(prefAlimentari: preferenze);
  }

  void removeInteresseCulinario(String interesse, List<String> interessi) {
    interessi.remove(interesse);
    state = state.copyWith(interessiCulinari: interessi);
  }

  void removeAlergeno(String allergene, List<String> allergie) {
    allergie.remove(allergene);
    state = state.copyWith(allergie: allergie);
  }

  void onNewBioChanged(String value) {
    final bio = Bio.dirty(value);
    state = state.copyWith(
        newBio: bio, status: Formz.validate([bio, state.newNickname!]));
  }

  void onPrefAlimentariChanged(List<String> value) {
    state = state.copyWith(prefAlimentari: value);
  }

  void onNewPhotoChanged(Uint8List value) {
    state = state.copyWith(newPhoto: value);
  }

  void onAllergieChanged(List<String> value) {
    state = state.copyWith(allergie: value);
  }

  void onInteressiCulinariChanged(List<String> value) {
    state = state.copyWith(interessiCulinari: value);
  }

  void updateProfile(AuthUser oldUser) async {
    state = state.copyWith(status: FormzStatus.submissionInProgress);

    final profiloImmagine = state.newPhotoUrl ?? oldUser.photoURL;

    if (oldUser.nickname == state.newNickname!.value &&
        oldUser.bio == state.newBio!.value &&
        oldUser.prefAlimentari == state.prefAlimentari &&
        oldUser.allergie == state.allergie &&
        oldUser.interessiCulinari == state.interessiCulinari &&
        oldUser.photoURL == profiloImmagine) {
      state = state.copyWith(status: FormzStatus.submissionSuccess);
      return;
    }

    if (state.newNickname!.value.isEmpty) {
      state = state.copyWith(
        newNickname: Nickname.dirty(oldUser.nickname!),
      );
    }
    if (state.newBio!.value.isEmpty) {
      state = state.copyWith(
        newBio: Bio.dirty(oldUser.bio!),
      );
    }

    if (state.interessiCulinari.isEmpty) {
      state = state.copyWith(
        interessiCulinari: oldUser.interessiCulinari,
      );
    }

    if (state.prefAlimentari.isEmpty) {
      state = state.copyWith(
        prefAlimentari: oldUser.prefAlimentari,
      );
    }

    if (state.allergie.isEmpty) {
      state = state.copyWith(
        allergie: oldUser.allergie,
      );
    }

    oldUser = oldUser.copyWith(
      photoURL: profiloImmagine,
      nickname: state.newNickname!.value,
      bio: state.newBio!.value,
      prefAlimentari: state.prefAlimentari,
      allergie: state.allergie,
      interessiCulinari: state.interessiCulinari,
    );

    try {
      await _firebaseRepo.updateProfile(oldUser, state.newPhoto);

      state = state.copyWith(status: FormzStatus.submissionSuccess);

      //reload page
      html.window.location.reload();
    } on UpdateProfileFailure catch (e) {
      state = state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: e.code,
      );
    }
  }
}
