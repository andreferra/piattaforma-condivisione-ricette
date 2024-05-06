import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Ingredienti extends ConsumerWidget {
  const Ingredienti({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    List<String> misure = ["grammi", "millilitri", "litri", "chilogrammi"];

    final recipeState = ref.watch(addRecipesProvider);
    final recipeController = ref.read(addRecipesProvider.notifier);
    return Column(
      children: [
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: TextInputField(
                    hintText: "Ingrediente",
                    onChanged: (p0) {
                      recipeController.onIngredientiChanged(p0);
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextInputField(
                    hintText: "Quantità",
                    onChanged: (p0) {
                      recipeController.onQuantitaChanged(p0);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                    child:  DropdownButton<String>(
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
                      items: misure
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toUpperCase(), selectionColor: Colors.white,),
                        );
                      }).toList(),
                    )
                ),
                AnimatedButton(
                    onTap: () {
                      recipeController.addIngredienti();
                    },
                    child: const RoundedButtonStyle(
                      title: "Aggiungi",
                      orizzontalePadding: 18,
                      verticalePadding: 12,
                    )),
              ],
            ),
            spacer(0, 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              child:  ListView.builder(
                itemCount: recipeState.ingredienti.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onLongPress: () {
                      recipeController.removeIngredienti(recipeState.ingredienti[index]);
                    },

                    title: Text(recipeState.ingredienti[index]),
                  );
                },
              )
            ),
          ],
        ),
      ],
    );
  }
}
