import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:condivisionericette/widget/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
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
                          child: RecipeListItem(
                              imageUrl: document["cover_image"],
                              title: document["nome_piatto"],
                              description: document["descrizione"],
                              key: ValueKey(document.id)));
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
