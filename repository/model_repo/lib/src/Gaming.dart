import 'package:model_repo/src/SfideGame.dart';

enum GameName {
  reginaDellaPasta,
  maestroDiDolci,
  reDellaPizza,
  grillMaster5000,
  sushiChef,
}

class Gaming {
  GameName gameName;
  int punti;
  int sfideVinte;
  int sfidePartecipate = 0;
  List<Sfidegame>? sfide = [];

  Gaming({
    this.gameName = GameName.reginaDellaPasta,
    this.punti = 0,
    this.sfideVinte = 0,
    this.sfidePartecipate = 0,
    this.sfide,
  });

  Gaming.empty() : this();

  Gaming copyWith({
    GameName? gameName,
    int? punti,
    int? sfideVinte,
    int? sfidePartecipate,
    List<Sfidegame>? sfide,
  }) {
    return Gaming(
      gameName: gameName ?? this.gameName,
      punti: punti ?? this.punti,
      sfideVinte: sfideVinte ?? this.sfideVinte,
      sfidePartecipate: sfidePartecipate ?? this.sfidePartecipate,
      sfide: sfide ?? this.sfide,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameName': gameName.toString(),
      'punti': punti,
      'sfideVinte': sfideVinte,
      'sfidePartecipate': sfidePartecipate,
      'sfide': sfide!.map((e) => e.toMap()).toList(),
    };
  }

  factory Gaming.fromMap(Map<String, dynamic> map) {
    try {
      print(map);
      return Gaming(
        gameName:
            GameName.values.firstWhere((e) => e.toString() == map['gameName']),
        punti: map['punti'],
        sfideVinte: map['sfideVinte'],
        sfidePartecipate: map['sfidePartecipate'],
        sfide: (map['sfide'] as List<dynamic>)
            .map((e) => Sfidegame.fromMap(e))
            .toList(),
      );
    } catch (e) {
      print("Errore Gaming.fromMap: ${e.toString()}");
      return Gaming.empty();
    }
  }
}
