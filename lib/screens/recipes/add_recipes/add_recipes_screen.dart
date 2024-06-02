// Flutter imports:

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/components/Allergie.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/Ingredienti.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/ReceptStep.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/Tag.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/header_recipes.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/loading_errors.dart';
// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRecipesScreen extends ConsumerWidget {
  final bool sfida;
  final String sfidaId;
  const AddRecipesScreen({super.key, this.sfida = false, this.sfidaId = ""});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<RecipesState>(addRecipesProvider, (previous, current) {
      if (current.status == StateRecipes.inProgress) {
        LoadingSheet.show(context);
      } else if (current.status == StateRecipes.error) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "Errore pubblicazione della ricetta");
      } else if (current.status == StateRecipes.done) {
        SnackBar snackBar = const SnackBar(
          content: Text("Impostazioni aggiornate con successo"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return Scaffold(
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: const Ingredienti(),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: const Allergie(),
                  ),
                ),
                Expanded(
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
            const ReceptsStep(),
          ],
        ),
      ),
    );
  }
}
