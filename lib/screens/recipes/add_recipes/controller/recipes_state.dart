part of 'recipes_controller.dart';

class RecipesState extends Equatable {
  final String? nomePiatto;
  final String? descrizione;
  final int? tempoPreparazione;
  final int? porzioni;
  final String? difficolta;
  final List<Uint8List> immagini;
  final List<String> ingredienti;
  final List<String> tag;
  final List<String> passaggi;
  final List<String> allergie;
  final Uint8List? coverImage;

  //utili
  final String? ingrediente;
  final String? tagSingolo;
  final String? passaggio;
  final String? allergia;
  final String? misura;
  final String? quantita;


  const RecipesState({
    this.nomePiatto,
    this.descrizione,
    this.tempoPreparazione,
    this.porzioni,
    this.difficolta = "facile",
    this.immagini = const [],
    this.ingredienti = const [],
    this.tag = const [],
    this.passaggi = const [],
    this.allergie = const [],
    this.ingrediente,
    this.tagSingolo,
    this.passaggio,
    this.allergia,
    this.misura,
    this.quantita,
    this.coverImage,
  });

  RecipesState copyWith({
    String? nomePiatto,
    String? descrizione,
    int? tempoPreparazione,
    int? porzioni,
    String? difficolta,
    List<Uint8List>? immagini,
    List<String>? ingredienti,
    List<String>? tag,
    List<String>? passaggi,
    List<String>? allergie,
    String? ingrediente,
    String? tagSingolo,
    String? passaggio,
    String? allergia,
    String? misura,
    String? quantita,
    Uint8List? coverImage,
  }) {
    return RecipesState(
      nomePiatto: nomePiatto ?? this.nomePiatto,
      descrizione: descrizione ?? this.descrizione,
      tempoPreparazione: tempoPreparazione ?? this.tempoPreparazione,
      porzioni: porzioni ?? this.porzioni,
      difficolta: difficolta ?? this.difficolta,
      immagini: immagini ?? this.immagini,
      ingredienti: ingredienti ?? this.ingredienti,
      tag: tag ?? this.tag,
      passaggi: passaggi ?? this.passaggi,
      allergie: allergie ?? this.allergie,
      ingrediente: ingrediente ?? this.ingrediente,
      tagSingolo: tagSingolo ?? this.tagSingolo,
      passaggio: passaggio ?? this.passaggio,
      allergia: allergia ?? this.allergia,
      misura: misura ?? this.misura,
      quantita: quantita ?? this.quantita,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  @override
  List<Object?> get props => [
        nomePiatto,
        descrizione,
        tempoPreparazione,
        porzioni,
        difficolta,
        immagini,
        ingredienti,
        tag,
        passaggi,
        allergie,
        ingrediente,
        tagSingolo,
        passaggio,
        allergia,
        misura,
        quantita,
        coverImage,
      ];
}
