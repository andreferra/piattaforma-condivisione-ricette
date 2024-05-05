import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralInfo extends ConsumerWidget {
  const GeneralInfo({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final recipeState = ref.watch(addRecipesProvider);
    final recipeController = ref.read(addRecipesProvider.notifier);
    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextInputField(
                    hintText: "Ingrediente (grammi)",
                    onChanged: (p0) {
                      recipeController.onIngredientiChanged(p0);
                    },
                  ),
                ),
                AnimatedButton(
                    onTap: () {
                      recipeController.addIngredienti(recipeState.ingrediente!);
                    },
                    child: const RoundedButtonStyle(
                      title: "Aggiungi",
                      orizzontalePadding: 18,
                      verticalePadding: 12,
                    )),
              ],
            ),
            spacer(0, 10),
            Wrap(
              spacing: 10,
              children: recipeState.ingredienti
                  .map((ingrediente) => Chip(
                        label: Text(ingrediente),
                        onDeleted: () {
                          recipeController.removeIngredienti(ingrediente);
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
