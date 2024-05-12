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
  final bool? notification;

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
    this.notification = true,
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
        notification,
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
      notification: data['notification'],
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
      'notification': notification,
    };
  }

  AuthUser copyWith({
    String? uid,
    String? email,
    String? password,
    String? name,
    String? nickname,
    bool? emailVerified,
    String? phone,
    String? photoURL,
    String? dataRegistrazione,
    String? dataUltimoAccesso,
    bool? isLogged,
    List<String>? prefAlimentari,
    List<String>? allergie,
    List<String>? interessiCulinari,
    String? bio,
    bool? notification,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      emailVerified: emailVerified ?? this.emailVerified,
      phone: phone ?? this.phone,
      photoURL: photoURL ?? this.photoURL,
      dataRegistrazione: dataRegistrazione ?? this.dataRegistrazione,
      dataUltimoAccesso: dataUltimoAccesso ?? this.dataUltimoAccesso,
      isLogged: isLogged ?? this.isLogged,
      prefAlimentari: prefAlimentari ?? this.prefAlimentari,
      allergie: allergie ?? this.allergie,
      interessiCulinari: interessiCulinari ?? this.interessiCulinari,
      bio: bio ?? this.bio,
      notification: notification ?? this.notification,
    );
  }
}
