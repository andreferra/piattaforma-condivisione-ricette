// Flutter imports:

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// Project imports:
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/screens/feed_screen/components/new_message.dart';
import 'package:condivisionericette/screens/feed_screen/components/new_notification.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/view_recipe_screen.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:condivisionericette/widget/recipe_card.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final firebase = ref.watch(firebaseRepoProvider);

    return Scaffold(
      body: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: defaultPadding * 3),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(pageControllerProvider).setPage(2);
                    },
                    child: NewNotification(
                      userId: user.uid,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  InkWell(
                      onTap: () {
                        ref.read(pageControllerProvider).setPage(6);
                      },
                      child: NewMessage(
                        userID: user.uid,
                      )),
                  // sfida corrente
                ],
              ),
              Text(user.uid),
              Text(user.name!),
              Text(user.email!),
              Text(user.photoURL!),
              Text(user.bio!),
              Text(user.prefAlimentari!.toString()),
              Text(user.allergie!.toString()),
              Text(user.interessiCulinari!.toString()),
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
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: InkWell(
                              onTap: () async {
                                firebase.updateVisualizations(document.id);

                                bool isMine = user.uid == document['user_id'];

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewRecipeScreen(
                                        mediaRecensioni:
                                            document['media_recensioni']
                                                .toDouble(),
                                        visualizzazioni:
                                            document['numero_visualizzazioni'] +
                                                1,
                                        mioId: user.uid,
                                        isMine: isMine,
                                        recipesState: RecipesState.fromSnapshot(
                                            document))));
                              },
                              child: RecipeListItem(
                                title: document['nome_piatto'],
                                imageUrl: document['cover_image'],
                                description: document['descrizione'],
                                numeroLike: document['numero_like'].toString(),
                                numeroCommenti:
                                    document['numero_commenti'].toString(),
                                visualizzazioni:
                                    document['numero_visualizzazioni']
                                        .toString(),
                                numeroCondivisioni:
                                    document['numero_condivisioni'].toString(),
                              )));
                    }).toList(),
                  );
                },
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(pageControllerProvider).setPage(5);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
