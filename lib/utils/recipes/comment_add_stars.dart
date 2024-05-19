import 'package:condivisionericette/screens/recipes/view_screen/controller/recipe_interaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStars extends ConsumerWidget {
  const AddStars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeInteractionController =
        ref.watch(recipeInteractionProvider.notifier);

    final nStarSelected = ref.watch(recipeInteractionProvider).numeroStelle ?? 1;

    const Icon star = Icon(
      Icons.star,
      size: 20,
    );
    const Icon starSelected = Icon(
      Icons.star,
      size: 20,
      color: Colors.yellow,
    );
    return SizedBox(
      child: Row(
        children: [
          for (int i = 1; i <= 5; i++)
            IconButton(
              icon: i <= nStarSelected ? starSelected : star,
              onPressed: () {
                print(i);
                recipeInteractionController.onSetStars(i);
              },
            ),
        ],
      ),
    );
  }
}
