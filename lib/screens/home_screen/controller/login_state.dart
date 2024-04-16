part of "login_controller.dart";

class LoginState extends Equatable {
  final String email;
  final String password;
  final String? errorMessage;
  final LoginStatus status;

  const LoginState({
    this.email = "",
    this.password = "",
    this.errorMessage,
    this.status = LoginStatus.initial
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    LoginStatus? status
  }) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        errorMessage: errorMessage,
        status: status ?? this.status
    );
  }

  @override
  List<Object?> get props => [email, password, errorMessage, status];
}

enum LoginStatus {
  initial,
  compile,
  loading,
  success,
  error
}