enum GameName {
  ReginaDellaPasta,
  MaestroDiDolci,
  ReDellaPizza,
  GrillMaster5000,
  SushiChef,
}

class Gaming {
  GameName gameName;
  int punti;
  int sfideVinte;
  int sfidePartecipate = 0;

  Gaming({
    this.gameName = GameName.ReginaDellaPasta,
    this.punti = 0,
    this.sfideVinte = 0,
    this.sfidePartecipate = 0,
  });

  Gaming.empty() : this();

  Gaming copyWith({
    GameName? gameName,
    int? punti,
    int? sfideVinte,
    int? sfidePartecipate,
  }) {
    return Gaming(
      gameName: gameName ?? this.gameName,
      punti: punti ?? this.punti,
      sfideVinte: sfideVinte ?? this.sfideVinte,
      sfidePartecipate: sfidePartecipate ?? this.sfidePartecipate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameName': gameName.toString(),
      'punti': punti,
      'sfideVinte': sfideVinte,
      'sfidePartecipate': sfidePartecipate,
    };
  }

  factory Gaming.fromMap(Map<String, dynamic> map) {
    return Gaming(
      gameName:
          GameName.values.firstWhere((e) => e.toString() == map['gameName']),
      punti: map['punti'],
      sfideVinte: map['sfideVinte'],
      sfidePartecipate: map['sfidePartecipate'],
    );
  }
}
