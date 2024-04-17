
import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String uid;
  final String? email;
  final String? password;
  final String? name;
  final String? nickname;
  final bool emailVerified;
  final String? phone;
  final String? photoURL;
  final String? dataRegistrazione;
  final String? dataUltimoAccesso;
  final bool isLogged;

  const AuthUser({
    required this.uid,
    this.email,
    this.password,
    this.name,
    this.nickname,
    this.emailVerified = false,
    this.phone,
    this.photoURL,
    this.dataRegistrazione,
    this.dataUltimoAccesso,
    this.isLogged = false,
  });

  static const empty = AuthUser(uid: '');

  bool get isEmpty => this == AuthUser.empty;

  @override
  List<Object?> get props => [
    uid,
    email,
    password,
    name,
    nickname,
    emailVerified,
    phone,
    photoURL,
    dataRegistrazione,
    dataUltimoAccesso,
    isLogged,
  ];

  factory AuthUser.fromDocument(Map<String, dynamic> data) {
    return AuthUser(
      uid: data['id'],
      email: data['email'],
      password: data['password'],
      name: data['name'],
      nickname: data['nickname'],
      emailVerified: data['emailVerified'],
      phone: data['phone'],
      photoURL: data['photoURL'],
      dataRegistrazione: data['dataRegistrazione'],
      dataUltimoAccesso: data['dataUltimoAccesso'],
      isLogged: data['isLogged'],
    );
  }


  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'nickname': nickname,
      'emailVerified': emailVerified,
      'phone': phone,
      'photoURL': photoURL,
      'dataRegistrazione': dataRegistrazione,
      'dataUltimoAccesso': dataUltimoAccesso,
      'isLogged': isLogged,
    };
  }


}