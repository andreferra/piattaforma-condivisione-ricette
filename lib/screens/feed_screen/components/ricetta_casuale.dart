// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/view_recipe_screen.dart';

class RicettaCasuale extends StatefulWidget {
  final AuthUser user;
  const RicettaCasuale({super.key, required this.user});

  @override
  State<RicettaCasuale> createState() => _RicettaCasualeState();
}

class _RicettaCasualeState extends State<RicettaCasuale> {
  AuthUser get user => widget.user;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection('recipes')
                  .get()
                  .then((value) {
                //genera un numero casuale tra 0 e il numero di ricette presenti
                int randomIndex = Random().nextInt(value.docs.length);

                final random = value.docs[randomIndex];
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewRecipeScreen(
                          mediaRecensioni:
                              random['media_recensioni'].toDouble(),
                          isMine: user.uid == random['user_id'],
                          visualizzazioni: random['numero_visualizzazioni'] + 1,
                          mioId: user.uid,
                          recipesState: RecipesState.fromSnapshot(random),
                        )));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Prova qualcosa di nuovo!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
        ],
      ),
    );
  }
}
