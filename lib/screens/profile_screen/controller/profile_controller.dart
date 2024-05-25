// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';
import 'package:universal_html/html.dart' as html;

// Project imports:
import 'package:condivisionericette/controller/auth_repo_provider.dart';

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

    AuthUser user = AuthUser(
      uid: oldUser.uid,
      email: oldUser.email,
      name: oldUser.name,
      nickname: state.newNickname!.value.isEmpty
          ? oldUser.nickname
          : state.newNickname!.value,
      phone: oldUser.phone,
      password: oldUser.password,
      emailVerified: oldUser.emailVerified,
      dataRegistrazione: oldUser.dataRegistrazione,
      dataUltimoAccesso: oldUser.dataUltimoAccesso,
      isLogged: oldUser.isLogged,
      photoURL: profiloImmagine,
      bio: state.newBio!.value.isEmpty ? oldUser.bio : state.newBio!.value,
      prefAlimentari: state.prefAlimentari.isEmpty
          ? oldUser.prefAlimentari
          : state.prefAlimentari,
      allergie: state.allergie.isEmpty ? oldUser.allergie : state.allergie,
      interessiCulinari: state.interessiCulinari.isEmpty
          ? oldUser.interessiCulinari
          : state.interessiCulinari,
    );

    try {
      await _firebaseRepo.updateProfile(user, state.newPhoto);

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
