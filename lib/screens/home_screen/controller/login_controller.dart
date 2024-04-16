import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'login_state.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>(
        (ref) => LoginController(ref.watch(authRepoProvider)));

class LoginController extends StateNotifier<LoginState> {
  final AuthenticationRepository _authRepo;

  LoginController(this._authRepo) : super(const LoginState());

  void onEmailChanged(String email) {
    email = email.trim();

    state = state.copyWith(
      email: email,
      status: LoginStatus.compile,
    );
  }

  void onPasswordChanged(String password) {
    password = password.trim();

    state = state.copyWith(
      password: password,
      status: LoginStatus.compile,
    );
  }

  void signInWithEmailAndPassword() async {
    state = state.copyWith(status: LoginStatus.loading);

    try {
      await _authRepo.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      state = state.copyWith(status: LoginStatus.success);
    } on SignInWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
        errorMessage: e.code,
        status: LoginStatus.error,
      );
    }
  }
}
