// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';

class Ingredientisfida extends ConsumerWidget {
  final List<String> ingredienti;
  const Ingredientisfida({super.key, required this.ingredienti});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeController = ref.read(addRecipesProvider.notifier);
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: ingredienti
          .map((e) => Chip(
                label: Text(e),
                onDeleted: () {
                  recipeController.onIngredientiSfidaChanged(
                      ingredienti.where((element) => element != e).toList());
                },
              ))
          .toList(),
    );
  }
}
