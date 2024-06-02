part of 'recipes_controller.dart';

class RecipesState extends Equatable {
  final String? nomePiatto;
  final String? descrizione;
  final int? tempoPreparazione;
  final int? porzioni;
  final String? difficolta;
  final List<String> ingredienti;
  final List<String> tag;
  final List<String> allergie;
  final Uint8List? coverImage;
  final String? recipeID;
  final String? userID;
  final Timestamp? dataCreazione;
  final String? errorMessage;
  final ErrorType errorType;

  //utili
  final String? ingrediente;
  final String? tagSingolo;
  final String? passaggio;
  final String? allergia;
  final String? misura;
  final String? quantita;

  //step
  final List<Uint8List> immagini;
  final List<String> passaggi;
  final int? stepIndex;
  final Uint8List? stepImage;
  final String? stepText;
  final String? linkCoverImage;
  final List<String>? linkStepImages;
  final RecipeInteraction? recipeInteraction;
  final StateRecipes status;
  final FileState fileState;

  const RecipesState(
      {this.recipeID,
      this.nomePiatto,
      this.descrizione,
      this.dataCreazione,
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
      this.stepIndex = 0,
      this.stepImage,
      this.stepText,
      this.linkCoverImage,
      this.linkStepImages,
      this.userID,
      this.recipeInteraction,
      this.status = StateRecipes.initial,
      this.fileState = FileState.initial,
      this.errorMessage,
      this.errorType = ErrorType.nessuno});

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
    int? stepIndex,
    Uint8List? stepImage,
    String? stepText,
    String? linkCoverImage,
    List<String>? linkStepImages,
    String? recipeID,
    RecipeInteraction? recipeInteraction,
    StateRecipes? status,
    FileState? fileState,
    String? errorMessage,
    ErrorType? errorType,
  }) {
    return RecipesState(
      recipeID: recipeID ?? this.recipeID,
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
      stepIndex: stepIndex ?? this.stepIndex,
      stepImage: stepImage ?? this.stepImage,
      stepText: stepText ?? this.stepText,
      status: status ?? this.status,
      recipeInteraction: recipeInteraction ?? this.recipeInteraction,
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorType ?? this.errorType,
    );
  }

  //converti fa snapshot in RecipesState
  factory RecipesState.fromSnapshot(DocumentSnapshot document) {
    List<Comment> commenti = [];
    if (document['commenti'] != null && document['commenti'].isNotEmpty) {
      try {
        List<dynamic> risposte = document['commenti'][0]['risposte'];

        if (risposte.isNotEmpty) {
          commenti = risposte.map((risposta) {
            return Comment.fromMap(risposta);
          }).toList();
        }
      } catch (e) {
        print(e);
      }
    }
    return RecipesState(
      userID: document["user_id"],
      recipeID: document["uid"],
      nomePiatto: document["nome_piatto"],
      descrizione: document["descrizione"],
      dataCreazione: document["data_creazione"],
      tempoPreparazione: document["tempo_preparazione"],
      porzioni: document["porzioni"],
      difficolta: document["difficolta"],
      passaggi: List<String>.from(document["step_texts"]),
      linkStepImages: List<String>.from(document["step_images"]),
      ingredienti: List<String>.from(document["ingredienti"]),
      tag: List<String>.from(document["tag"]),
      allergie: List<String>.from(document["allergie"]),
      linkCoverImage: document["cover_image"],
      recipeInteraction: RecipeInteraction(
        dataCreazione: document["data_creazione"],
        commenti: commenti,
        like: document["like"],
        numeroCommenti: document["numero_commenti"],
        numeroLike: document["numero_like"],
        numeroCondivisioni: document["numero_condivisioni"],
        visualizzazioni: document["numero_visualizzazioni"],
      ),
    );
  }

  @override
  List<Object?> get props => [
        nomePiatto,
        recipeID,
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
        stepIndex,
        stepImage,
        stepText,
        linkCoverImage,
        linkStepImages,
        recipeInteraction,
        status,
        fileState,
        errorMessage,
        errorType,
      ];
}
