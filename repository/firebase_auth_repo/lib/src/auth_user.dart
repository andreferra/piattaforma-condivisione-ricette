import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String uid;
  final String? email;
  final String? password;
  final String? name;
  final String? nickname;
  final bool? emailVerified;
  final String? phone;
  final String? photoURL;
  final String? dataRegistrazione;
  final String? dataUltimoAccesso;
  final bool? isLogged;
  final List<String>? prefAlimentari;
  final List<String>? allergie;
  final List<String>? interessiCulinari;
  final String? bio;

  const AuthUser({
    required this.uid,
    this.email,
    this.password,
    this.name,
    this.nickname,
    this.emailVerified,
    this.phone,
    this.photoURL,
    this.dataRegistrazione,
    this.dataUltimoAccesso,
    this.isLogged,
    this.prefAlimentari,
    this.allergie,
    this.interessiCulinari,
    this.bio,
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
        prefAlimentari,
        allergie,
        interessiCulinari,
        bio,
      ];

  factory AuthUser.fromDocument(Map<String, dynamic> data) {
    return AuthUser(
      uid: data['uid'],
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
      prefAlimentari: (data['prefAlimentari'] as List<dynamic>).map((item) => item.toString()).toList(),
      allergie: (data['allergie'] as List<dynamic>).map((item) => item.toString()).toList(),
      interessiCulinari: (data['interessiCulinari'] as List<dynamic>).map((item) => item.toString()).toList(),
      bio: data['bio'],
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
      'prefAlimentari': prefAlimentari,
      'allergie': allergie,
      'interessiCulinari': interessiCulinari,
      'bio': bio,
    };
  }
}
