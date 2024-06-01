import 'dart:typed_data';

enum SfideType { none, image, ingredients }

class Sfidegame {
  String id;
  String name;
  String description;
  String image;
  int partecipanti;
  List<String> utentiPartecipanti;
  List<String> classifica;
  int punti;
  SfideType type;
  List<String>? ingredienti;
  List<Uint8List>? immagini;
  List<String>? urlImmagini;
  DateTime? dataCreazione;
  DateTime? dataFine;
  DateTime? dataInizio;

  Sfidegame({
    this.id = '',
    this.name = '',
    this.description = '',
    this.image = '',
    this.partecipanti = 0,
    this.utentiPartecipanti = const [],
    this.classifica = const [],
    this.punti = 0,
    this.type = SfideType.none,
    this.ingredienti,
    this.immagini,
    this.urlImmagini,
    this.dataCreazione,
    this.dataFine,
    this.dataInizio,
  });

  Sfidegame.empty() : this();

  Sfidegame copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    int? partecipanti,
    SfideType? type,
    List<String>? utentiPartecipanti,
    List<String>? classifica,
    int? punti,
    List<String>? ingredienti,
    List<Uint8List>? immagini,
    List<String>? urlImmagini,
    DateTime? dataCreazione,
    DateTime? dataFine,
    DateTime? dataInizio,
  }) {
    return Sfidegame(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      type: type ?? this.type,
      partecipanti: partecipanti ?? this.partecipanti,
      utentiPartecipanti: utentiPartecipanti ?? this.utentiPartecipanti,
      classifica: classifica ?? this.classifica,
      punti: punti ?? this.punti,
      ingredienti: ingredienti ?? this.ingredienti,
      immagini: immagini ?? this.immagini,
      urlImmagini: urlImmagini ?? this.urlImmagini,
      dataCreazione: dataCreazione ?? this.dataCreazione,
      dataFine: dataFine ?? this.dataFine,
      dataInizio: dataInizio ?? this.dataInizio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'partecipanti': partecipanti,
      'utentiPartecipanti': utentiPartecipanti,
      'classifica': classifica,
      'punti': punti,
      'type': type.index,
      'ingredienti': ingredienti,
      'immagini': immagini,
      'urlImmagini': urlImmagini,
      'dataCreazione': dataCreazione,
      'dataFine': dataFine,
      'dataInizio': dataInizio,
    };
  }

  factory Sfidegame.fromMap(Map<String, dynamic> map) {
    print(map);
    try {
      return Sfidegame(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        image: map['image'],
        partecipanti: map['partecipanti'],
        type: SfideType.values[map['type']],
        utentiPartecipanti: List<String>.from(map['utentiPartecipanti']),
        classifica: List<String>.from(map['classifica']),
        punti: map['punti'],
        ingredienti: map['ingredienti'] != null
            ? List<String>.from(map['ingredienti'])
            : [],
        urlImmagini: map['urlImmagini'] != null
            ? List<String>.from(map['urlImmagini'])
            : [],
        dataCreazione: map['dataCreazione'] != null
            ? map['dataCreazione'].toDate()
            : DateTime.now(),
        dataFine:
            map['dataFine'] != null ? map['dataFine'].toDate() : DateTime.now(),
        dataInizio: map['dataInizio'] != null
            ? map['dataInizio'].toDate()
            : DateTime.now(),
      );
    } catch (e) {
      print(e);
      return Sfidegame();
    }
  }
}
