// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/recipe_sfide/recipe_sfide.dart';
import 'package:condivisionericette/widget/sfide/sfide_my_recipe_card.dart';

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

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    await _firebaseRepository
                        .addViewToRecipe(
                      recipe.recipeID,
                      recipe.sfidaID,
                      recipe.userID,
                    )
                        .then(
                      (value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RecipeSfide(
                                  newRecipe: recipe.copyWith(
                                    visualizzazioni: [
                                      ...recipe.visualizzazioni,
                                      user.uid
                                    ],
                                  ),
                                  user: user,
                                )));
                      },
                    );
                  },
                  child: SfideMyRecipeCard(recipe: recipe),
                );
              } else {
                return const Center(child: Text('Nessuna ricetta pubblicata'));
              }
            }),
      ]),
    );
  }
}
