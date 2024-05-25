// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/view_recipe_screen.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipesList extends ConsumerWidget {
  final String userId;

  const RecipesList(this.userId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final firebase = ref.watch(firebaseRepoProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(defaultPadding),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('recipes')
              .where("user_id", isEqualTo: userId)
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
                          // aggiorna le visualizzazioni del post

                          firebase.updateVisualizations(document.id);

                          bool isMine = user.uid == document['user_id'];

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewRecipeScreen(
                                  visualizzazioni:
                                      document['numero_visualizzazioni'] + 1,
                                  mioId: user.uid,
                                  mediaRecensioni:
                                      document['media_recensioni'].toDouble(),
                                  isMine: isMine,
                                  recipesState:
                                      RecipesState.fromSnapshot(document))));
                        },
                        child: RecipeListItem(
                          title: document['nome_piatto'],
                          imageUrl: document['cover_image'],
                          description: document['descrizione'],
                          numeroLike: document['numero_like'].toString(),
                          numeroCommenti:
                              document['numero_commenti'].toString(),
                          visualizzazioni:
                              document['numero_visualizzazioni'].toString(),
                          numeroCondivisioni:
                              document['numero_condivisioni'].toString(),
                        )));
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
