// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';

class Ingredienti extends ConsumerWidget {
  const Ingredienti({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> misure = ["grammi", "millilitri", "litri", "chilogrammi"];

    final recipeState = ref.watch(addRecipesProvider);
    final recipeController = ref.read(addRecipesProvider.notifier);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextInputField(
                hintText: "Ingrediente",
                onChanged: (p0) {
                  recipeController.onIngredientiChanged(p0);
                },
              ),
            ),
            Expanded(
              child: TextInputField(
                hintText: "Quantità",
                onChanged: (p0) {
                  recipeController.onQuantitaChanged(p0);
                },
              ),
            ),
            Expanded(
                child: DropdownButton<String>(
              value: recipeState.misura,
              style: const TextStyle(color: Colors.white),
              autofocus: false,
              focusColor: Colors.transparent,
              alignment: Alignment.bottomCenter,
              borderRadius: BorderRadius.circular(12),
              underline: Container(
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                recipeController.onMisuraChanged(newValue!);
              },
              items: misure.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.toUpperCase(),
                    selectionColor: Colors.white,
                  ),
                );
              }).toList(),
            )),
            AnimatedButton(
                onTap: () {
                  recipeController.addIngredienti();
                },
                child: const RoundedButtonStyle(
                  title: "+",
                  orizzontalePadding: 18,
                  verticalePadding: 12,
                )),
          ],
        ),
        spacer(0, 10),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: recipeState.ingredienti.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipeState.ingredienti[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      recipeController
                          .removeIngredienti(recipeState.ingredienti[index]);
                    },
                  ),
                );
              },
            )),
      ],
    );
  }
}
