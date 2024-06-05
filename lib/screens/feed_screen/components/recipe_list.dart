// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/view_recipe_screen.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/recipe_card.dart';

class RecipeList extends StatefulWidget {
  final AuthUser user;
  const RecipeList({super.key, required this.user});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final FirebaseRepository firebase = FirebaseRepository();
  AuthUser get user => widget.user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("LE ULTIME RICETTE PUBBLICATE",
            style: Theme.of(context).textTheme.titleLarge),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("recipes")
              .orderBy("data_creazione", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong${snapshot.error}"),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Nessuna ricetta trovata"),
              );
            }
            return Column(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: InkWell(
                      onTap: () async {
                        firebase.updateVisualizations(document.id);

                        bool isMine = user.uid == document['user_id'];

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewRecipeScreen(
                                mediaRecensioni:
                                    document['media_recensioni'].toDouble(),
                                visualizzazioni:
                                    document['numero_visualizzazioni'] + 1,
                                mioId: user.uid,
                                isMine: isMine,
                                recipesState:
                                    RecipesState.fromSnapshot(document))));
                      },
                      child: Stack(
                        children: [
                          RecipeListItem(
                              imageUrl: document["cover_image"],
                              title: document["nome_piatto"],
                              description: document["descrizione"],
                              numeroLike: document["numero_like"].toString(),
                              numeroCommenti:
                                  document["numero_commenti"].toString(),
                              numeroCondivisioni:
                                  document["numero_condivisioni"].toString(),
                              visualizzazioni:
                                  document["numero_visualizzazioni"].toString(),
                              key: ValueKey(document.id)),
                          if (user.allergie!.isNotEmpty &&
                              document["allergie"].any((element) =>
                                  user.allergie!.contains(element)))
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'CONTIENE ALLERGIA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ));
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
