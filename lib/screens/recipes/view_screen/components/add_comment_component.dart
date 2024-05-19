import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/controller/recipe_interaction_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/utils/recipes/comment_add_stars.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCommentComponent extends ConsumerWidget {
  final RecipesState recipesState;
  final String title;
  final bool subComment;

  const AddCommentComponent(
      {super.key,
      required this.recipesState,
      required this.title,
      required this.subComment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final recipeInteractionController =
        ref.watch(recipeInteractionProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: defaultPadding * 2),
          TextInputField(
            hintText: "Inserisci un commento",
            onChanged: (value) {
              recipeInteractionController.onCommentTextChanged(value, user);
            },
          ),
          const SizedBox(height: defaultPadding),
          if (!subComment) ...[const AddStars()],
          const SizedBox(height: defaultPadding),
          AnimatedButton(
              onTap: () async {
                String res = "error";

                if (subComment) {
                  res = await recipeInteractionController
                      .addOnReply(recipesState.recipeID!);
                  return;
                } else if (!subComment) {
                  res = await recipeInteractionController
                      .onCommentSubmitted(recipesState.recipeID!);
                }

                switch (res) {
                  case "ok":
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Il tuo commento è stato pubblicato con successo!")));
                    break;
                  case "error":
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Errore")));
                    break;
                  default:
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Errore")));
                }
              },
              child: const RoundedButtonStyle(title: "Pubblica commento"))
        ],
      ),
    );
  }
}
