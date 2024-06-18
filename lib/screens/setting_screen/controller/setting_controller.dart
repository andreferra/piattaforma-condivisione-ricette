// Dart imports:

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_repo_provider.dart';

part 'setting_state.dart';

final settingProvider =
    StateNotifierProvider.autoDispose<SettingController, SettingState>(
        (ref) => SettingController(
              ref.watch(authRepoProvider),
              ref.watch(firebaseRepoProvider),
            ));

class SettingController extends StateNotifier<SettingState> {
  final AuthenticationRepository _authRepo;
  final FirebaseRepository _firebaseRepo;

  SettingController(this._authRepo, this._firebaseRepo)
      : super(const SettingState());

  void onNewEmailChanged(String value) {
    final email = Email.dirty(value.trim());
    state = state.copyWith(
      newEmail: email,
      status: Formz.validate([email]),
    );
  }

  void onNewPasswordChanged(String value) {
    final password = Password.dirty(value.trim());
    state = state.copyWith(
      newPassword: password,
      status: Formz.validate([password]),
    );
  }

  void onNotificationChanged(value) {
    state = state.copyWith(notification: value);
  }

  Future<bool> aggiornaImpostazioni(AuthUser oldUser) async {
    try {
      state = state.copyWith(status: FormzStatus.submissionInProgress);

      String email = state.newEmail!.value.isEmpty
          ? oldUser.email!
          : state.newEmail!.value;
      String password = state.newPassword!.value.isEmpty
          ? oldUser.password!
          : state.newPassword!.value;

      bool notifiche = state.notification ?? oldUser.notification!;

      if (state.newEmail!.value == oldUser.email &&
          state.newPassword!.value == oldUser.password &&
          state.notification == oldUser.notification) {
        state = state.copyWith(status: FormzStatus.submissionSuccess);
        return false;
      }

      if (state.status.isValidated) {
        // aggiorna preferenza notifiche utente
        await _firebaseRepo.updateUserSetting(notifiche, oldUser.uid);

        // aggiorna email e password utente

        await _authRepo.updatePassword(
            oldUser.email!, password, oldUser.password!);

        //gestire aggiormamento email
        await _authRepo.updateEmail(email, password);
      }

      state = state.copyWith(status: FormzStatus.submissionSuccess);
      if (email != oldUser.email) {
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> deleteAccount(String uid) async {
    try {
      state = state.copyWith(status: FormzStatus.submissionInProgress);
      await _authRepo.deleteAccount(uid);
      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } catch (e) {
      state = state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: e.toString(),
      );
    }
  }
}
