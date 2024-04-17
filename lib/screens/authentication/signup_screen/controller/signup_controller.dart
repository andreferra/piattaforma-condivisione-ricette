import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

part 'signup_state.dart';

final signUpProvider = StateNotifierProvider<SignUpController, SignUpState>(
  (ref) => SignUpController(ref.watch(authRepoProvider)),
);

class SignUpController extends StateNotifier<SignUpState> {
  final AuthenticationRepository _authRepo;

  SignUpController(this._authRepo) : super(const SignUpState());

  void onEmailChanged(String value) {
    value = value.trim();
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    );
  }

  void onPasswordChanged(String value) {
    value = value.trim();

    final password = Password.dirty(value);

    state = state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    );
  }

  void onNameChanged(String value) {
    value = value.trim();
    final name = Name.dirty(value);

    state = state.copyWith(
      name: name,
      status: Formz.validate([name]),
    );
  }

  void onNicknameChanged(String value) {
    value = value.trim();
    final nickname = Name.dirty(value);

    state = state.copyWith(
      nickname: nickname,
      status: Formz.validate([nickname]),
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
        phone: "not implemented yet",
      );

      state = state.copyWith(status: FormzStatus.submissionSuccess);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}
