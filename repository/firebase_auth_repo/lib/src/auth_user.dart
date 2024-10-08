import 'package:equatable/equatable.dart';
import 'package:model_repo/model_repo.dart';

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
  final List<String>? follower;
  final List<String>? following;
  final int? posts;
  final List<String>? userNotificheActive;
  final List<String>? listaNotifiche;
  final bool? newNotifiche;
  final bool? gameActive;
  final Gaming? gaming;

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
    this.userNotificheActive,
    this.allergie,
    this.interessiCulinari,
    this.bio,
    this.notification = true,
    this.listaNotifiche,
    this.follower,
    this.following,
    this.posts,
    this.newNotifiche,
    this.gameActive = false,
    this.gaming,
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
        userNotificheActive,
        dataRegistrazione,
        dataUltimoAccesso,
        isLogged,
        prefAlimentari,
        allergie,
        notification,
        interessiCulinari,
        bio,
        follower,
        following,
        listaNotifiche,
        posts,
        newNotifiche,
        gameActive,
        gaming,
      ];

  factory AuthUser.fromDocument(Map<String, dynamic> data) {
    try {
      return AuthUser(
        uid: data['uid'],
        email: data['email'],
        password: data['password'],
        name: data['name'],
        nickname: data['nickname'],
        emailVerified: data['emailVerified'],
        phone: data['phone'],
        newNotifiche: data['newNotifiche'],
        photoURL: data['photoURL'],
        userNotificheActive: (data['userNotificheActive'] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        gameActive: data['gameActive'],
        dataRegistrazione: data['dataRegistrazione'],
        dataUltimoAccesso: data['dataUltimoAccesso'],
        isLogged: data['isLogged'],
        prefAlimentari: (data['prefAlimentari'] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        allergie: (data['allergie'] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        interessiCulinari: (data['interessiCulinari'] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        bio: data['bio'],
        notification: data['notification'],
        follower: (data['follower'] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        following: (data['following'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        posts: data['posts'],
        listaNotifiche: (data['listaNotifiche'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        gaming: data['gaming'] != null
            ? Gaming.fromMap(data['gaming'])
            : Gaming.empty(),
      );
    } catch (e) {
      print("Errore AuthUser.fromDocument: ${e.toString()}");
      return AuthUser.empty;
    }
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'newNotifiche': newNotifiche,
      'name': name,
      'nickname': nickname,
      'emailVerified': emailVerified,
      'phone': phone,
      'photoURL': photoURL,
      'dataRegistrazione': dataRegistrazione,
      'dataUltimoAccesso': dataUltimoAccesso,
      'isLogged': isLogged,
      'gameActive': gameActive,
      'prefAlimentari': prefAlimentari,
      'allergie': allergie,
      'interessiCulinari': interessiCulinari,
      'bio': bio,
      'notification': notification,
      'userNotificheActive': userNotificheActive,
      'follower': follower,
      'following': following,
      'posts': posts,
      'listaNotifiche': listaNotifiche,
      'gaming': gaming?.toMap(),
    };
  }

  AuthUser copyWith({
    String? uid,
    String? email,
    String? password,
    String? name,
    String? nickname,
    bool? emailVerified,
    bool? gameActive,
    String? phone,
    String? photoURL,
    String? dataRegistrazione,
    String? dataUltimoAccesso,
    bool? isLogged,
    bool? newNotifiche,
    List<String>? prefAlimentari,
    List<String>? allergie,
    List<String>? interessiCulinari,
    String? bio,
    List<String>? userNotificheActive,
    bool? notification,
    List<String>? follower,
    List<String>? following,
    int? posts,
    List<String>? listaNotifiche,
    Gaming? gaming,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      gameActive: gameActive ?? this.gameActive,
      password: password ?? this.password,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      emailVerified: emailVerified ?? this.emailVerified,
      phone: phone ?? this.phone,
      photoURL: photoURL ?? this.photoURL,
      userNotificheActive: userNotificheActive ?? this.userNotificheActive,
      dataRegistrazione: dataRegistrazione ?? this.dataRegistrazione,
      dataUltimoAccesso: dataUltimoAccesso ?? this.dataUltimoAccesso,
      newNotifiche: newNotifiche ?? this.newNotifiche,
      isLogged: isLogged ?? this.isLogged,
      prefAlimentari: prefAlimentari ?? this.prefAlimentari,
      allergie: allergie ?? this.allergie,
      interessiCulinari: interessiCulinari ?? this.interessiCulinari,
      bio: bio ?? this.bio,
      notification: notification ?? this.notification,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      listaNotifiche: listaNotifiche ?? this.listaNotifiche,
      gaming: gaming ?? this.gaming,
    );
  }
}
