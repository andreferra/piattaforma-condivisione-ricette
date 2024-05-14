import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? idCommento;
  final String? userId;
  final String? commento;
  final Timestamp? dataCreazione;
  final String? nicknameUtente;
  final String? urlUtente;
  final int? numeroStelle;


  Comment({
    this.idCommento,
    this.userId,
    this.commento,
    this.dataCreazione,
    this.nicknameUtente,
    this.urlUtente,
    this.numeroStelle,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      idCommento: map['idCommento'],
      userId: map['userId'],
      commento: map['commento'],
      dataCreazione: map['dataCreazione'],
      nicknameUtente: map['nicknameUtente'],
      urlUtente: map['urlUtente'],
      numeroStelle: map['numeroStelle'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCommento': idCommento,
      'userId': userId,
      'commento': commento,
      'dataCreazione': dataCreazione,
      'nicknameUtente': nicknameUtente,
      'urlUtente': urlUtente,
      'numeroStelle': numeroStelle,
    };
  }

  //empty comment
  static Comment get empty => Comment(
    idCommento: '',
    userId: '',
    commento: '',
    dataCreazione: Timestamp.now(),
    nicknameUtente: '',
    urlUtente: '',
    numeroStelle: 0,
  );

}
