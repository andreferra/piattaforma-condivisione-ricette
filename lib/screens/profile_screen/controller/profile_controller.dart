import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

part "profile_state.dart";

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileState>(
        (ref) => ProfileController(ref.watch(authRepoProvider)));

class ProfileController extends StateNotifier<ProfileState> {
  final AuthenticationRepository _authRepo;
  late FirebaseRepository _firebaseRepo;

  ProfileController(this._authRepo) : super(const ProfileState());

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

  void checkAllergeno(String allergene) {
    final allergeno = Allergeni.dirty(allergene);
    state = state.copyWith(
        allergeno: allergeno,
        status: Formz.validate([allergeno]));
  }

  void checkInteresseCulinario(String interesse) {
    final interesseCulinario = InteressiCulinari.dirty(interesse);
    state = state.copyWith(
        interesseCulinario: interesseCulinario,
        status: Formz.validate([interesseCulinario]));
  }

  void onNewAllergenoChanged(String value , List<String> allergie)  {
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

  void onNewInteresseCulinarioChanged(String value , List<String> interessi)  {
    try {
      final interesseCulinario = InteressiCulinari.dirty(value);

      if (interesseCulinario.valid && !interessi.contains(interesseCulinario.value.toString())) {
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

  void onAllergieChanged(List<String> value) {
    state = state.copyWith(allergie: value);
  }

  void onInteressiCulinariChanged(List<String> value) {
    state = state.copyWith(interessiCulinari: value);
  }

  void updateProfile(AuthUser oldUser) async {
    if (!state.status.isValidated) return;

    state = state.copyWith(status: FormzStatus.submissionInProgress);

    AuthUser user = AuthUser(
        uid: oldUser.uid,
        email: oldUser.email,
        name: oldUser.name,
        nickname: state.newNickname!.value,
        phone: oldUser.phone,
        password: oldUser.password,
        emailVerified: oldUser.emailVerified,
        dataRegistrazione: oldUser.dataRegistrazione,
        dataUltimoAccesso: oldUser.dataUltimoAccesso,
        isLogged: oldUser.isLogged,
        photoURL: state.newPhotoUrl,
        bio: state.newBio!.value,
        prefAlimentari: state.prefAlimentari,
        allergie: state.allergie,
        interessiCulinari: state.interessiCulinari);

    try {
      await _firebaseRepo.updateProfile(user);
      state = state.copyWith(status: FormzStatus.submissionSuccess);
      //TODO: update current user state
    } on UpdateProfileFailure catch (e) {
      state = state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: e.code,
      );
    }
  }
}
