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

  //utili
  final String? ingrediente;
  final String? tagSingolo;
  final String? passaggio;
  final String? allergia;

  const RecipesState({
    this.nomePiatto,
    this.descrizione,
    this.tempoPreparazione,
    this.porzioni,
    this.difficolta,
    this.immagini = const [],
    this.ingredienti = const [],
    this.tag = const [],
    this.passaggi = const [],
    this.allergie = const [],
    this.ingrediente,
    this.tagSingolo,
    this.passaggio,
    this.allergia,
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
      ];
}
