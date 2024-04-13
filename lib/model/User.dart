

class User{
  String id;
  String name;
  String email;
  String password;
  String phone;
  String nickname;
  DateTime dataRegistrazione;
  DateTime dataUltimoAccesso;
  bool isLogged;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.nickname,
    required this.dataRegistrazione,
    required this.dataUltimoAccesso,
    required this.isLogged,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      nickname: json['nickname'],
      dataRegistrazione: json['dataRegistrazione'],
      dataUltimoAccesso: json['dataUltimoAccesso'],
      isLogged: json['isLogged'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'nickname': nickname,
      'dataRegistrazione': dataRegistrazione,
      'dataUltimoAccesso': dataUltimoAccesso,
      'isLogged': isLogged,
    };
  }

}

