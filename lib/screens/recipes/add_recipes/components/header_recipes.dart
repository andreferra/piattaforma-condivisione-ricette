/*
 Questo componente conterrà:
 - titolo della ricetta
 - descrizione della ricetta
 - difficoltà della ricetta
 - tempo di preparazione della ricetta
  - porzioni della ricetta
*/

// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/text_input_field.dart';

class HeaderRecipes extends ConsumerWidget {
  const HeaderRecipes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> difficolta = ["facile", "media", "difficile"];

    final recipesController = ref.watch(addRecipesProvider.notifier);
    final recipesState = ref.watch(addRecipesProvider);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'AGGIUNGI UNA NUOVA RICETTA',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const SizedBox(height: defaultPadding * 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: TextInputField(
                        hintText: "Inserisci titolo della ricetta",
                        onChanged: (value) {
                          recipesController.onNomePiattoChanged(value);
                        }),
                  ),
                  const SizedBox(height: defaultPadding * 3),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: TextInputField(
                        hintText: "Inserisci una breve descrizione",
                        onChanged: (value) {
                          recipesController.onDescrizioneChanged(value);
                        }),
                  ),
                ],
              ),
              const SizedBox(width: defaultPadding * 5),
              //inserisci piking immagine
              const Column(children: [
                Text("Inserisci un'immagine di copertina"),
                AddCoverImage(),
              ]),
            ],
          ),
          const SizedBox(height: defaultPadding * 5),
          Row(
            children: [
              Expanded(
                  child: DropdownButton<String>(
                value: recipesState.difficolta,
                style: const TextStyle(color: Colors.white),
                autofocus: false,
                focusColor: Colors.transparent,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(12),
                underline: Container(
                  color: Colors.white,
                ),
                onChanged: (String? newValue) {
                  recipesController.onDifficoltaChanged(newValue!);
                },
                items: difficolta.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.toUpperCase(),
                      selectionColor: Colors.white,
                    ),
                  );
                }).toList(),
              )),
              const SizedBox(width: defaultPadding * 2),
              Expanded(
                child: TextInputField(
                    hintText: "Tempo di preparazione (minuti)",
                    onChanged: (value) {
                      recipesController
                          .onTempoPreparazioneChanged(int.parse(value));
                    }),
              ),
              const SizedBox(width: defaultPadding * 2),
              Expanded(
                child: TextInputField(
                    hintText: "Numero di porzioni",
                    onChanged: (value) {
                      recipesController.onPorzioniChanged(int.parse(value));
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AddCoverImage extends ConsumerWidget {
  const AddCoverImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesController = ref.watch(addRecipesProvider.notifier);
    final coverImage = ref.watch(addRecipesProvider).coverImage;
    return InkWell(
      onTap: () async {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image != null) {
          Uint8List file = await image.readAsBytes();
          recipesController.onCoverImageChanged(file);
        }
      },
      child: coverImage == null
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
                  image: Image.memory(coverImage).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
