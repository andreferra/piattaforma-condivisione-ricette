class Recipesfide {
  /// Nome del piatto
  final String nomePiatto;

  /// Descrizione del piatto
  final String descrizione;
  final int tempoPreparazione;
  final int porzioni;
  final String difficolta;
  final List<String> ingredienti;
  final List<String> tag;
  final List<String> passaggi;
  final List<String> allergie;
  final List<String> immaginiPassaggi;
  final String coverImage;
  final String userID;
  final String sfidaID;
  final String recipeID;
  final int totaleVoti;
  final int votiPositivi;
  final int votiNegativi;
  final int visualizzazioni;
  final List<String> utentiVotanti;

  const Recipesfide({
    required this.nomePiatto,
    required this.descrizione,
    required this.tempoPreparazione,
    required this.porzioni,
    required this.difficolta,
    required this.ingredienti,
    required this.tag,
    required this.passaggi,
    required this.allergie,
    required this.immaginiPassaggi,
    required this.coverImage,
    required this.userID,
    required this.sfidaID,
    required this.recipeID,
    required this.totaleVoti,
    required this.votiPositivi,
    required this.votiNegativi,
    required this.visualizzazioni,
    required this.utentiVotanti,
  });

  Recipesfide.empty()
      : this(
          nomePiatto: '',
          descrizione: '',
          tempoPreparazione: 0,
          porzioni: 0,
          sfidaID: '',
          difficolta: '',
          ingredienti: [],
          tag: [],
          passaggi: [],
          allergie: [],
          immaginiPassaggi: [],
          coverImage: '',
          userID: '',
          recipeID: '',
          totaleVoti: 0,
          votiPositivi: 0,
          votiNegativi: 0,
          visualizzazioni: 0,
          utentiVotanti: [],
        );

  Recipesfide copyWith({
    String? nomePiatto,
    String? descrizione,
    int? tempoPreparazione,
    int? porzioni,
    String? difficolta,
    List<String>? ingredienti,
    List<String>? tag,
    String? sfidaID,
    List<String>? passaggi,
    List<String>? allergie,
    List<String>? immaginiPassaggi,
    String? coverImage,
    String? userID,
    String? recipeID,
    int? totaleVoti,
    int? votiPositivi,
    int? votiNegativi,
    int? visualizzazioni,
    List<String>? utentiVotanti,
  }) {
    return Recipesfide(
      nomePiatto: nomePiatto ?? this.nomePiatto,
      descrizione: descrizione ?? this.descrizione,
      tempoPreparazione: tempoPreparazione ?? this.tempoPreparazione,
      porzioni: porzioni ?? this.porzioni,
      difficolta: difficolta ?? this.difficolta,
      ingredienti: ingredienti ?? this.ingredienti,
      tag: tag ?? this.tag,
      passaggi: passaggi ?? this.passaggi,
      allergie: allergie ?? this.allergie,
      immaginiPassaggi: immaginiPassaggi ?? this.immaginiPassaggi,
      coverImage: coverImage ?? this.coverImage,
      userID: userID ?? this.userID,
      recipeID: recipeID ?? this.recipeID,
      totaleVoti: totaleVoti ?? this.totaleVoti,
      votiPositivi: votiPositivi ?? this.votiPositivi,
      votiNegativi: votiNegativi ?? this.votiNegativi,
      visualizzazioni: visualizzazioni ?? this.visualizzazioni,
      utentiVotanti: utentiVotanti ?? this.utentiVotanti,
      sfidaID: sfidaID ?? this.sfidaID,
    );
  }

  factory Recipesfide.fromSnapshot(Map<String, dynamic> snapshot) {
    return Recipesfide(
      nomePiatto: snapshot['nomePiatto'] ?? '',
      descrizione: snapshot['descrizione'] ?? '',
      tempoPreparazione: snapshot['tempoPreparazione'] ?? 0,
      porzioni: snapshot['porzioni'] ?? 0,
      difficolta: snapshot['difficolta'] ?? '',
      ingredienti: List<String>.from(snapshot['ingredienti'] ?? []),
      tag: List<String>.from(snapshot['tag'] ?? []),
      passaggi: List<String>.from(snapshot['passaggi'] ?? []),
      allergie: List<String>.from(snapshot['allergie'] ?? []),
      immaginiPassaggi: List<String>.from(snapshot['immaginiPassaggi'] ?? []),
      coverImage: snapshot['coverImage'] ?? '',
      userID: snapshot['userID'] ?? '',
      recipeID: snapshot['recipeID'] ?? '',
      totaleVoti: snapshot['totaleVoti'] ?? 0,
      sfidaID: snapshot['sfidaID'] ?? '',
      votiPositivi: snapshot['votiPositivi'] ?? 0,
      votiNegativi: snapshot['votiNegativi'] ?? 0,
      visualizzazioni: snapshot['visualizzazioni'] ?? 0,
      utentiVotanti: List<String>.from(snapshot['utentiVotanti'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nomePiatto': nomePiatto,
      'sfidaID': sfidaID,
      'descrizione': descrizione,
      'tempoPreparazione': tempoPreparazione,
      'porzioni': porzioni,
      'difficolta': difficolta,
      'ingredienti': ingredienti,
      'tag': tag,
      'passaggi': passaggi,
      'allergie': allergie,
      'immaginiPassaggi': immaginiPassaggi,
      'coverImage': coverImage,
      'userID': userID,
      'recipeID': recipeID,
      'totaleVoti': totaleVoti,
      'votiPositivi': votiPositivi,
      'votiNegativi': votiNegativi,
      'visualizzazioni': visualizzazioni,
      'utentiVotanti': utentiVotanti,
    };
  }
}
