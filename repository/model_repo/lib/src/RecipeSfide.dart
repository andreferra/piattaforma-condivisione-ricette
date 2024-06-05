class Recipesfide {
  /// `nomePiatto` is a string representing the name of the dish.
  final String nomePiatto;

  /// `descrizione` is a string providing a description of the dish.
  final String descrizione;

  /// `tempoPreparazione` is an integer representing the preparation time for the dish in minutes.
  final int tempoPreparazione;

  /// `porzioni` is an integer representing the number of servings the dish makes.
  final int porzioni;

  /// `difficolta` is a string indicating the difficulty level of preparing the dish.
  final String difficolta;

  /// `ingredienti` is a list of strings, each string being an ingredient required for the dish.
  final List<String> ingredienti;

  /// `tag` is a list of strings, each string being a tag associated with the dish.
  final List<String> tag;

  /// `passaggi` is a list of strings, each string being a step in the preparation of the dish.
  final List<String> passaggi;

  /// `allergie` is a list of strings, each string being an allergen present in the dish.
  final List<String> allergie;

  /// `immaginiPassaggi` is a list of strings, each string being a URL to an image showing a step in the preparation of the dish.
  final List<String> immaginiPassaggi;

  /// `coverImage` is a string representing a URL to the cover image of the dish.
  final String coverImage;

  /// `userID` is a string representing the ID of the user who posted the dish.
  final String userID;

  /// `sfidaID` is a string representing the ID of the challenge associated with the dish.
  final String sfidaID;

  /// `recipeID` is a string representing the unique ID of the dish.
  final String recipeID;

  /// `votiPositivi` is a list of strings, each string being the ID of a user who gave a positive rating to the dish.
  final List<String> votiPositivi;

  /// `votiNegativi` is a list of strings, each string being the ID of a user who gave a negative rating to the dish.
  final List<String> votiNegativi;

  /// `visualizzazioni` is a list of strings, each string being the ID of a user who viewed the dish.
  final List<String> visualizzazioni;

  /// `score` is an integer representing the score of the dish based on views, positive ratings, and negative ratings.
  final int score;

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
    required this.votiPositivi,
    required this.votiNegativi,
    required this.visualizzazioni,
    this.score = 0,
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
          votiPositivi: [],
          votiNegativi: [],
          visualizzazioni: [],
          score: 0,
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
    List<String>? votiPositivi,
    List<String>? votiNegativi,
    List<String>? visualizzazioni,
    int? score,
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
      votiPositivi: votiPositivi ?? this.votiPositivi,
      votiNegativi: votiNegativi ?? this.votiNegativi,
      visualizzazioni: visualizzazioni ?? this.visualizzazioni,
      sfidaID: sfidaID ?? this.sfidaID,
      score: score ?? this.score,
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
      sfidaID: snapshot['sfidaID'] ?? '',
      votiPositivi: List<String>.from(snapshot['votiPositivi']),
      votiNegativi: List<String>.from(snapshot['votiNegativi']),
      visualizzazioni: List<String>.from(snapshot['visualizzazioni']),
      score: snapshot['score'] ?? 0,
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
      'votiPositivi': votiPositivi,
      'votiNegativi': votiNegativi,
      'visualizzazioni': visualizzazioni,
      'score': score,
    };
  }
}
