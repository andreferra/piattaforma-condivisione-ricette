import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tag extends ConsumerWidget {
  const Tag({super.key});

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
                hintText: "Tag",
                onChanged: (p0) {
                  recipeController.onTagChanged(p0);
                },
              ),
            ),
            AnimatedButton(
                onTap: () {
                  recipeController.addTag();
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
            itemCount: recipeState.tag.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(recipeState.tag[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    recipeController.removeTag(recipeState.tag[index]);
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
