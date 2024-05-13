import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/controller/recipe_interaction_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCommentComponent extends ConsumerWidget {
  const AddCommentComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final recipeInteractionController =
        ref.watch(recipeInteractionProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          const Text("Lascia un commento alla ricetta",
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: defaultPadding * 2),
          TextInputField(
            hintText: "Inserisci un commento",
            onChanged: (value) {
              recipeInteractionController.onCommentTextChanged(value, user);
            },
          ),
          const SizedBox(height: defaultPadding),
          AnimatedButton(
              onTap: () {

              },
              child: const RoundedButtonStyle(title: "Pubblica commento"))
        ],
      ),
    );
  }
}
