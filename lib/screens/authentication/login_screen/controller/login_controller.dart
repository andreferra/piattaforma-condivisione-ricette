import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

part 'login_state.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>(
        (ref) => LoginController(ref.watch(authRepoProvider)));

class LoginController extends StateNotifier<LoginState> {
  final AuthenticationRepository _authRepo;

  LoginController(this._authRepo) : super(const LoginState());

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

  void signInWithEmailAndPassword() async {
    if (!state.status.isValidated) return;

    state = state.copyWith(status: FormzStatus.submissionInProgress);

    try {
      await _authRepo
          .signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      ).then((value) {
        state = state.copyWith(status: FormzStatus.submissionSuccess);  });
    } on SignInWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.code);
    }
  }
}
