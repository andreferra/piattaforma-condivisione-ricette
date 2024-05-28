import 'dart:typed_data';

class Sfidegame {
  String id;
  String name;
  String description;
  String image;
  int partecipanti;
  List<String> utentiPartecipanti;
  List<String> classifica;
  int punti;
  List<String>? ingredienti;
  List<Uint8List>? immagini;
  List<String>? urlImmagini;

  Sfidegame({
    this.id = '',
    this.name = '',
    this.description = '',
    this.image = '',
    this.partecipanti = 0,
    this.utentiPartecipanti = const [],
    this.classifica = const [],
    this.punti = 0,
    this.ingredienti,
    this.immagini,
    this.urlImmagini,
  });

  Sfidegame.empty() : this();

  Sfidegame copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    int? partecipanti,
    List<String>? utentiPartecipanti,
    List<String>? classifica,
    int? punti,
    List<String>? ingredienti,
    List<Uint8List>? immagini,
    List<String>? urlImmagini,
  }) {
    return Sfidegame(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      partecipanti: partecipanti ?? this.partecipanti,
      utentiPartecipanti: utentiPartecipanti ?? this.utentiPartecipanti,
      classifica: classifica ?? this.classifica,
      punti: punti ?? this.punti,
      ingredienti: ingredienti ?? this.ingredienti,
      immagini: immagini ?? this.immagini,
      urlImmagini: urlImmagini ?? this.urlImmagini,
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
      'ingredienti': ingredienti,
      'immagini': immagini,
      'urlImmagini': urlImmagini,
    };
  }

  factory Sfidegame.fromMap(Map<String, dynamic> map) {
    try {
      return Sfidegame(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        image: map['image'],
        partecipanti: map['partecipanti'],
        utentiPartecipanti: List<String>.from(map['utentiPartecipanti']),
        classifica: List<String>.from(map['classifica']),
        punti: map['punti'],
        ingredienti: List<String>.from(map['ingredienti']),
        urlImmagini: List<String>.from(map['urlImmagini']),
      );
    } catch (e) {
      return Sfidegame();
    }
  }
}
