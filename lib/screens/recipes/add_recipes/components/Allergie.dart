import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Allergie extends ConsumerWidget {
  const Allergie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(addRecipesProvider);
    final recipeController = ref.read(addRecipesProvider.notifier);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextInputField(
                hintText: "Allergia",
                onChanged: (p0) {
                  recipeController.onAllergieChanged(p0);
                },
              ),
            ),
            AnimatedButton(
                onTap: () {
                  print(recipeState.allergia);
                  recipeController.addAllergie();
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
            itemCount: recipeState.allergie.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(recipeState.allergie[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    recipeController.removeAllergie(recipeState.allergie[index]);
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
