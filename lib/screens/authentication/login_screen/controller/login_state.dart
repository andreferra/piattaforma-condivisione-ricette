part of "login_controller.dart";

class LoginState extends Equatable {
  final Email email;
  final Password password;
  final String? errorMessage;
  final FormzStatus status;

  const LoginState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.errorMessage,
      this.status = FormzStatus.pure});

  LoginState copyWith(
      {Email? email,
      Password? password,
      String? errorMessage,
      FormzStatus? status}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        errorMessage: errorMessage,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [email, password, status];
}
