part of 'signup_controller.dart';

class SignUpState extends Equatable {
  final Email email;
  final Password password;
  final Name name;
  final Name nickname;
  final String? errorMessage;
  final FormzStatus status;
  //add phone number

  const SignUpState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.name = const Name.pure(),
      this.nickname = const Name.pure(),
      this.errorMessage,
      this.status = FormzStatus.pure});

  SignUpState copyWith(
      {Email? email,
      Password? password,
      Name? name,
      Name? nickname,
      String? errorMessage,
      FormzStatus? status}) {
    return SignUpState(
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        nickname: nickname ?? this.nickname,
        errorMessage: errorMessage,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [email, password, name, nickname, status];
}
