// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/recipe_sfide/recipe_sfide.dart';
import 'package:condivisionericette/widget/sfide/sfide_recipe_card.dart';

class RicettePubblicate extends StatefulWidget {
  final String sfidaId;
  final String userId;
  final AuthUser user;
  const RicettePubblicate(
      {super.key,
      required this.sfidaId,
      required this.userId,
      required this.user});

  @override
  State<RicettePubblicate> createState() => _RicettePubblicateState();
}

class _RicettePubblicateState extends State<RicettePubblicate> {
  String get sfidaId => widget.sfidaId;
  String get userId => widget.userId;
  AuthUser get user => widget.user;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipesfide>>(
        future: _firebaseRepository.getRicettePubbllicateSfida(sfidaId, userId),
        builder:
            (BuildContext context, AsyncSnapshot<List<Recipesfide>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Errore durante il caricamento delle ricette'),
            );
          }
          if (snapshot.hasData) {
            final List<Recipesfide> ricette = snapshot.data!;
            if (ricette.isEmpty) {
              return const Center(
                child: Text('Nessuna ricetta pubblicata'),
              );
            }
            // ordina ricette per score
            ricette.sort((a, b) => b.score.compareTo(a.score));
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: ricette.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      await _firebaseRepository
                          .addViewToRecipe(
                        ricette[index].recipeID,
                        ricette[index].sfidaID,
                        user.uid,
                      )
                          .then(
                        (value) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RecipeSfide(
                                    newRecipe: ricette[index].copyWith(
                                      visualizzazioni: [
                                        ...ricette[index].visualizzazioni,
                                        user.uid
                                      ],
                                    ),
                                    user: user,
                                  )));
                        },
                      );
                    },
                    child: SfideRecipeCard(recipe: ricette[index]),
                  );
                });
          }

          return const Center(
            child: Text('Nessuna ricetta pubblicata'),
          );
        });
  }
}
