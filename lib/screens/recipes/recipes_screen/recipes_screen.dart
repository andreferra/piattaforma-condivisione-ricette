// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/view_recipe_screen.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:condivisionericette/widget/recipe_card.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(authProvider).user.uid;
    return Scaffold(
      body: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            SingleChildScrollView(
              primary: false,
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("recipes")
                    .where("user_id", isEqualTo: userId)
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
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewRecipeScreen(
                                        isMine: true,
                                        mioId: userId,
                                        mediaRecensioni:
                                            document["media_recensioni"]
                                                .toDouble(),
                                        recipesState: RecipesState.fromSnapshot(
                                            document))));
                              },
                              child: RecipeListItem(
                                  imageUrl: document["cover_image"],
                                  title: document["nome_piatto"],
                                  description: document["descrizione"],
                                  numeroLike:
                                      document["numero_like"].toString(),
                                  numeroCommenti:
                                      document["numero_commenti"].toString(),
                                  numeroCondivisioni:
                                      document["numero_condivisioni"]
                                          .toString(),
                                  visualizzazioni:
                                      document["numero_visualizzazioni"]
                                          .toString(),
                                  key: ValueKey(document.id))));
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(pageControllerProvider).setPage(5);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
