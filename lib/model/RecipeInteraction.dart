import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeInteraction extends Equatable {
  final List<String>? commenti;
  final Timestamp? dataCreazione;
  final List? like;
  final int? numeroCommenti;
  final int? numeroLike;
  final int? numeroCondivisioni;
  final int? visualizzazioni;

  const RecipeInteraction({
    this.commenti,
    this.dataCreazione,
    this.like,
    this.numeroCommenti,
    this.numeroLike,
    this.numeroCondivisioni,
    this.visualizzazioni,
  });

  @override
  List<Object?> get props => [
        commenti,
        dataCreazione,
        like,
        numeroCommenti,
        numeroLike,
        numeroCondivisioni,
        visualizzazioni,
      ];
}
