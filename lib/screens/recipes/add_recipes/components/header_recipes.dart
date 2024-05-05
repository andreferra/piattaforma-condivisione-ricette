/*
 Questo componente conterrà:
 - titolo della ricetta
 - descrizione della ricetta
 - difficoltà della ricetta
 - tempo di preparazione della ricetta
  - porzioni della ricetta
*/

import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderRecipes extends ConsumerWidget {
  const HeaderRecipes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesState = ref.watch(addRecipesProvider.notifier);

    return Container(
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
          TextInputField(
              hintText: "Inserisci titolo della ricetta",
              onChanged: (value) {
                recipesState.onNomePiattoChanged(value);
              }),
          const SizedBox(height: defaultPadding * 3),
          TextInputField(
              hintText: "Inserisci una breve descrizione",
              onChanged: (value) {
                recipesState.onDescrizioneChanged(value);
              }),
          const SizedBox(height: defaultPadding * 3),
          Row(
            children: [
              Expanded(
                child: TextInputField(
                    hintText: "Difficoltà (Facile, Media, Difficile)",
                    onChanged: (value) {
                      recipesState.onDifficoltaChanged(value);
                    }),
              ),
              const SizedBox(width: defaultPadding * 2),
              Expanded(
                child: TextInputField(
                    hintText: "Tempo di preparazione (minuti)",
                    onChanged: (value) {
                      recipesState.onTempoPreparazioneChanged(int.parse(value));
                    }),
              ),
              const SizedBox(width: defaultPadding * 2),
              Expanded(
                child: TextInputField(
                    hintText: "Numero di porzioni",
                    onChanged: (value) {
                      recipesState.onPorzioniChanged(int.parse(value));
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
