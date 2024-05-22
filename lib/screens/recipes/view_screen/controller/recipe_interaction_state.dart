part of 'recipe_interaction_controller.dart';

enum UploadComment { initial, loading, loaded, error }

class RecipeInteraction extends Equatable {
  final List<Comment>? commenti;
  final Timestamp? dataCreazione;
  final List? like;
  final int? numeroCommenti;
  final int? numeroLike;
  final int? numeroCondivisioni;
  final int? visualizzazioni;

  final Comment? commento;
  final int? numeroStelle;
  final List<Uint8List>? imageFile;
  final UploadComment? uploadComment;
  final String? errorMex;

  bool? reply;
  final String? idCommentoReply;

  RecipeInteraction({
    this.commenti = const [],
    this.dataCreazione,
    this.like,
    this.numeroCommenti,
    this.numeroLike,
    this.numeroCondivisioni,
    this.visualizzazioni,
    this.commento,
    this.numeroStelle,
    this.reply = false,
    this.idCommentoReply,
    this.imageFile = const [],
    this.uploadComment = UploadComment.initial,
    this.errorMex,
  });

  RecipeInteraction copyWith({
    List<Comment>? commenti,
    Timestamp? dataCreazione,
    List? like,
    int? numeroCommenti,
    int? numeroLike,
    int? numeroCondivisioni,
    int? visualizzazioni,
    Comment? commento,
    int? numeroStelle,
    bool? reply,
    String? idCommentoReply,
    List<Uint8List>? imageFile,
    UploadComment? uploadComment,
    String? errorMex,
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
      reply: reply ?? this.reply,
      idCommentoReply: idCommentoReply ?? this.idCommentoReply,
      imageFile: imageFile ?? this.imageFile,
      uploadComment: uploadComment ?? this.uploadComment,
      errorMex: errorMex ?? this.errorMex,
    );
  }

  @override
  List<Object?> get props => [
        commenti,
        dataCreazione,
        like,
        numeroCommenti,
        reply,
        numeroLike,
        numeroCondivisioni,
        visualizzazioni,
        commento,
        numeroStelle,
        idCommentoReply,
        imageFile,
        uploadComment,
        errorMex,
      ];
}
