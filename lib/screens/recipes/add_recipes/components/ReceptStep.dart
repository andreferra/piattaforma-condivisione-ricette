import 'dart:typed_data';

import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ReceptsStep extends ConsumerWidget {
  const ReceptsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesController = ref.watch(addRecipesProvider.notifier);
    final recipesState = ref.watch(addRecipesProvider);
    final stepImage = recipesState.stepImage;
    final loadState = ref.watch(addRecipesProvider).state;
    final user = ref.watch(authProvider).user;

    return Column(
      children: [
        // form creazione step
        const SizedBox(
          height: defaultPadding * 3,
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: Row(
            children: [
              //immagine dello step
              InkWell(
                onTap: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    Uint8List file = await image.readAsBytes();
                    recipesController.addStepImage(file);
                  }
                },
                child: stepImage == null
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 50,
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: Image.memory(stepImage).image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              //descrizione dello step
              Expanded(
                child: TextInputField(
                  hintText: "Descrizione step",
                  minLines: 6,
                  hasMaxLenght: true,
                  maxLength: 500,
                  onChanged: (value) {
                    recipesController.addStepText(value);
                  },
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        AnimatedButton(
            onTap: () {
              try {
                recipesController.addStep();
              } catch (e) {
                print(e);
              }
            },
            child: const RoundedButtonStyle(
              title: "Aggiungi step",
              orizzontalePadding: 18,
              verticalePadding: 12,
            )),
        const SizedBox(
          height: defaultPadding * 3,
        ),

        if (recipesState.passaggi.isNotEmpty)
          for (int i = 0; i < recipesState.passaggi.length; i++)
            Column(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: [
                    Text(
                      "PASSAGGIO ${i + 1}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        recipesController.removeStep(i);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      recipesState.passaggi[i],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: defaultPadding * 3,
                    ),
                    if (recipesState.immagini.isNotEmpty)
                      Image.memory(
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width * 0.1,
                        recipesState.immagini[i],
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding * 3,
                ),

              ],
            ),
        if (recipesState.passaggi.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(defaultPadding * 2),
            child: AnimatedButton(
                onTap: () async {
                  try {
                    await recipesController.addRecipes(user);
                  } catch (e) {
                    print(e);
                  }
                },
                child: loadState == StateRecipes.initial
                    ? const RoundedButtonStyle(
                  title: "PUBBLICA RICETTA",
                  orizzontalePadding: 18,
                  verticalePadding: 12,
                  bgColor: Colors.green,
                )
                    : const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )),
          ),
      ],
    );
  }
}
