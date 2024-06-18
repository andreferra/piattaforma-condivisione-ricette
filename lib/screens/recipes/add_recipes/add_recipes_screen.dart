// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/components/Allergie.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/Ingredienti.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/IngredientiSfida.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/ReceptStep.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/Tag.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/header_recipes.dart';
import 'package:condivisionericette/utils/constant.dart';

class AddRecipesScreen extends ConsumerWidget {
  final bool sfida;
  final SfideType sfideType;
  final String sfidaId;
  final List<String> ingredienti;
  final List<String> urlImmagini;
  const AddRecipesScreen(
      {super.key,
      this.sfida = false,
      this.sfideType = SfideType.none,
      this.sfidaId = "",
      this.urlImmagini = const [],
      this.ingredienti = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseRepository firebaseRepository = FirebaseRepository();

    return Scaffold(
      appBar: sfida
          ? AppBar(
              title: const Text("Aggiungi ricetta per la sfida"),
            )
          : null,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding * 1.25,
            ),
            const HeaderRecipes(),
            const SizedBox(
              height: defaultPadding,
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: sfideType == SfideType.ingredients
                        ? Ingredientisfida(ingredienti: ingredienti)
                        : const Ingredienti(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: const Allergie(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: const Tag(),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            //inizio seconda parte della ricetta con gli step
            const SizedBox(height: defaultPadding * 3),
            if (sfideType == SfideType.image)
              Column(
                children: [
                  const Text(
                      "Ecco le immagini che devi usare per la tua ricetta"),
                  const SizedBox(height: defaultPadding),
                  FutureBuilder<Sfidegame>(
                      future: firebaseRepository.getSfidaById(sfidaId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Text(
                              "Errore durante il caricamento delle immagini");
                        }
                        return GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.urlImmagini!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0),
                            itemBuilder: (context, index) {
                              return Image.network(
                                snapshot.data!.urlImmagini![index],
                                fit: BoxFit.cover,
                                height: 150,
                                width: 150,
                              );
                            });
                      }),
                  const Divider(
                    height: 40,
                    thickness: 2,
                  ),
                  const SizedBox(height: defaultPadding * 3),
                ],
              ),
            Center(
              child: Text(
                'CREA GLI STEP DELLA RICETTA',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            const SizedBox(height: defaultPadding * 3),
            Receptstep(
              sfida: sfida,
              type: sfideType,
              sfidaId: sfidaId,
              urlImmagini: urlImmagini,
              ingredienti: ingredienti,
            )
          ],
        ),
      ),
    );
  }
}
