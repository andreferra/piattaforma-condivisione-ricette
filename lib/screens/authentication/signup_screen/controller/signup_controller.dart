// Package imports:

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_repo_provider.dart';

part 'signup_state.dart';

final signUpProvider =
    StateNotifierProvider.autoDispose<SignUpController, SignUpState>(
  (ref) => SignUpController(
      ref.read(authRepoProvider), ref.read(firebaseRepoProvider)),
);

class SignUpController extends StateNotifier<SignUpState> {
  final AuthenticationRepository _authRepo;
  final FirebaseRepository _firebaseRepo;

  SignUpController(this._authRepo, this._firebaseRepo)
      : super(const SignUpState());

  void onEmailChanged(String value) {
    value = value.trim();
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
        state.name,
        state.nickname,
        state.phone,
      ]),
    );
  }

  void onPasswordChanged(String value) {
    value = value.trim();

    final password = Password.dirty(value);

    state = state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        password,
        state.name,
        state.nickname,
        state.phone,
      ]),
    );
  }

  void onNameChanged(String value) {
    value = value.trim();
    final name = Name.dirty(value);

    state = state.copyWith(
      name: name,
      status: Formz.validate([
        name,
        state.email,
        state.password,
        state.nickname,
        state.phone,
      ]),
    );
  }

  Future<void> onNicknameChanged(String value) async {
    value = value.trim();
    final nickname = Nickname.dirty(value);

    await _firebaseRepo.checkNickname(value).then((isNicknameInUse) {
      if (isNicknameInUse) {
        state = state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: "Esiste già un utente con questo nickname");
      }
    });

    state = state.copyWith(
      nickname: nickname,
      status: Formz.validate([
        nickname,
        state.email,
        state.password,
        state.name,
        state.phone,
      ]),
    );
  }

  void onPhoneChanged(String value) {
    value = value.trim();
    final phone = Phone.dirty(value);

    state = state.copyWith(
      phone: phone,
      status: Formz.validate([
        phone,
        state.email,
        state.password,
        state.name,
        state.nickname,
      ]),
    );
  }

  void signUpWithEmailAndPassword() async {
    if (!state.status.isValidated) return;

    state = state.copyWith(status: FormzStatus.submissionInProgress);

    try {
      await _authRepo.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
        name: state.name.value,
        nickname: state.nickname.value,
        phone: state.phone.value,
      );

      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}
