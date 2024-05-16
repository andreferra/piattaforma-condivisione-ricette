import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? idCommento;
  final String? userId;
  final String? commento;
  final Timestamp? dataCreazione;
  final String? nicknameUtente;
  final String? urlUtente;
  final int? numeroStelle;
  final List<Comment>? risposte;

  Comment({
    this.idCommento,
    this.userId,
    this.commento,
    this.dataCreazione,
    this.nicknameUtente,
    this.urlUtente,
    this.numeroStelle = 1,
    this.risposte,
  });


  Comment copyWith({
    String? idCommento,
    String? userId,
    String? commento,
    Timestamp? dataCreazione,
    String? nicknameUtente,
    String? urlUtente,
    int? numeroStelle,
    List<Comment>? risposte,
  }) {
    return Comment(
      idCommento: idCommento ?? this.idCommento,
      userId: userId ?? this.userId,
      commento: commento ?? this.commento,
      dataCreazione: dataCreazione ?? this.dataCreazione,
      nicknameUtente: nicknameUtente ?? this.nicknameUtente,
      urlUtente: urlUtente ?? this.urlUtente,
      numeroStelle: numeroStelle ?? this.numeroStelle,
      risposte: risposte ?? this.risposte,
    );
  }



  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      idCommento: map['idCommento'],
      userId: map['userId'],
      commento: map['commento'],
      dataCreazione: map['dataCreazione'],
      nicknameUtente: map['nicknameUtente'],
      urlUtente: map['urlUtente'],
      numeroStelle: map['numeroStelle'],
      risposte: map['risposte'],

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
      'risposte': risposte,
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
        risposte: [],
      );
}
