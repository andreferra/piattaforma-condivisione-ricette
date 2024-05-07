import 'package:condivisionericette/screens/recipes/add_recipes/components/Allergie.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/Ingredienti.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/ReceptStep.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/Tag.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/header_recipes.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRecipesScreen extends ConsumerWidget {
  const AddRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
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
