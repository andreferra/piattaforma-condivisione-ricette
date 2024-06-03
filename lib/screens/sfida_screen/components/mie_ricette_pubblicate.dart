import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

class MieRicettePubblicate extends StatefulWidget {
  final String sfidaId;
  final AuthUser user;
  const MieRicettePubblicate(
      {super.key, required this.sfidaId, required this.user});

  @override
  State<MieRicettePubblicate> createState() => _MieRicettePubblicateState();
}

class _MieRicettePubblicateState extends State<MieRicettePubblicate> {
  String get sfidaId => widget.sfidaId;
  AuthUser get user => widget.user;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        const Text('La tua ricetta pubblicata per la sfida:'),
        const SizedBox(height: 20),
        FutureBuilder<Recipesfide>(
            future: _firebaseRepository.getUserSfideRecipe(sfidaId, user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(snapshot.error.toString().split(':').last));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                final Recipesfide recipe = snapshot.data!;

                return Column(
                  children: [
                    Text(recipe.nomePiatto),
                    Text(recipe.descrizione),
                    Text(recipe.tempoPreparazione.toString()),
                    Text(recipe.porzioni.toString()),
                    Text(recipe.difficolta),
                    Text(recipe.ingredienti.toString()),
                    Text(recipe.tag.toString()),
                    Text(recipe.passaggi.toString()),
                    Text(recipe.allergie.toString()),
                    Text(recipe.immaginiPassaggi.toString()),
                    Text(recipe.coverImage),
                    Text(recipe.userID),
                    Text(recipe.sfidaID),
                    Text(recipe.recipeID),
                    Text(recipe.totaleVoti.toString()),
                    Text(recipe.votiPositivi.toString()),
                    Text(recipe.votiNegativi.toString()),
                    Text(recipe.visualizzazioni.toString()),
                    Text(recipe.utentiVotanti.toString()),
                  ],
                );
              } else {
                return const Center(child: Text('Nessuna ricetta pubblicata'));
              }
            }),
      ]),
    );
  }
}
