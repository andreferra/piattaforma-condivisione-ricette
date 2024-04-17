part of 'signup_controller.dart';

class SignUpState extends Equatable {
  final Email email;
  final Password password;
  final Name name;
  final Nickname nickname;
  final Phone phone;
  final String? errorMessage;
  final FormzStatus status;

  const SignUpState(
      {this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.name = const Name.pure(),
      this.nickname = const Nickname.pure(),
      this.phone = const Phone.pure(),
      this.errorMessage,
      this.status = FormzStatus.pure});

  SignUpState copyWith(
      {Email? email,
      Password? password,
      Name? name,
      Nickname? nickname,
      Phone? phone,
      String? errorMessage,
      FormzStatus? status}) {
    return SignUpState(
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        nickname: nickname ?? this.nickname,
        phone: phone ?? this.phone,
        errorMessage: errorMessage,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [email, password, name, nickname, phone, status];
}
