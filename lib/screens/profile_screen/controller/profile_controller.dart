import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
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
