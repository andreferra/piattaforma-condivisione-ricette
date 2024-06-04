import 'package:condivisionericette/widget/sfide/sfide_recipe_card.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

class RicettePubblicate extends StatefulWidget {
  final String sfidaId;
  final String userId;
  const RicettePubblicate(
      {super.key, required this.sfidaId, required this.userId});

  @override
  State<RicettePubblicate> createState() => _RicettePubblicateState();
}

class _RicettePubblicateState extends State<RicettePubblicate> {
  String get sfidaId => widget.sfidaId;
  String get userId => widget.userId;
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
            // TODO : ordinare le ricette per classifica
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
                    onTap: () {},
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
