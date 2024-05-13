part of 'recipe_interaction_controller.dart';

class RecipeInteraction extends Equatable {
  final List<String>? commenti;
  final Timestamp? dataCreazione;
  final List? like;
  final int? numeroCommenti;
  final int? numeroLike;
  final int? numeroCondivisioni;
  final int? visualizzazioni;

  final Comment? commento;
  final int? numeroStelle;

  const RecipeInteraction({
    this.commenti,
    this.dataCreazione,
    this.like,
    this.numeroCommenti,
    this.numeroLike,
    this.numeroCondivisioni,
    this.visualizzazioni,
    this.commento,
    this.numeroStelle,
  });

  RecipeInteraction copyWith({
    List<String>? commenti,
    Timestamp? dataCreazione,
    List? like,
    int? numeroCommenti,
    int? numeroLike,
    int? numeroCondivisioni,
    int? visualizzazioni,
    Comment? commento,
    int? numeroStelle,
  }) {
    return RecipeInteraction(
      commenti: commenti ?? this.commenti,
      dataCreazione: dataCreazione ?? this.dataCreazione,
      like: like ?? this.like,
      numeroCommenti: numeroCommenti ?? this.numeroCommenti,
      numeroLike: numeroLike ?? this.numeroLike,
      numeroCondivisioni: numeroCondivisioni ?? this.numeroCondivisioni,
      visualizzazioni: visualizzazioni ?? this.visualizzazioni,
      commento: commento ?? this.commento,
      numeroStelle: numeroStelle ?? this.numeroStelle,
    );
  }

  @override
  List<Object?> get props => [
        commenti,
        dataCreazione,
        like,
        numeroCommenti,
        numeroLike,
        numeroCondivisioni,
        visualizzazioni,
        commento,
        numeroStelle,
      ];
}
