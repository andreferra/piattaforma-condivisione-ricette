import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/components/add_comment_component.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/utils/recipes/comment_view_components.dart';
import 'package:condivisionericette/utils/recipes/step_view_components.dart';
import 'package:flutter/material.dart';

class ViewRecipeScreen extends StatelessWidget {
  final bool isMine;
  final RecipesState recipesState;
  final int? visualizzazioni;

  const ViewRecipeScreen(
      {super.key,
      required this.recipesState,
      required this.isMine,
      this.visualizzazioni});

  @override
  Widget build(BuildContext context) {
    const spazio = SizedBox(height: defaultPadding * 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipesState.nomePiatto!.toUpperCase() ?? "Ricetta"),
        centerTitle: true,
        titleSpacing: 1,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            spazio,
            Row(
              children: [
                if (recipesState.linkCoverImage != null)
                  Image.network(
                    recipesState.linkCoverImage!,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipesState.descrizione ?? "",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    spazio,
                    Text(
                        "Tempo di preparazione: ${recipesState.tempoPreparazione} minuti",
                        style: const TextStyle(fontSize: 16)),
                    spazio,
                    Text("Porzioni: ${recipesState.porzioni}",
                        style: const TextStyle(fontSize: 16)),
                    spazio,
                    Text("Difficoltà: ${recipesState.difficolta}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: defaultPadding * 4),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Ingredienti",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    for (var i = 0; i < recipesState.ingredienti.length; i++)
                      Text(recipesState.ingredienti[i],
                          style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: defaultPadding * 4),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Allergie",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    for (var i = 0; i < recipesState.allergie.length; i++)
                      Text(recipesState.allergie[i],
                          style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: defaultPadding * 4),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tag",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    for (var i = 0; i < recipesState.tag.length; i++)
                      Text(recipesState.tag[i],
                          style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: defaultPadding * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    "Visualizzazioni: ${visualizzazioni ?? recipesState.recipeInteraction!.visualizzazioni}",
                    style: const TextStyle(fontSize: 16)),
                Text("Like: ${recipesState.recipeInteraction!.numeroLike}",
                    style: const TextStyle(fontSize: 16, color: Colors.green)),
                Text(
                    "Commenti: ${recipesState.recipeInteraction!.numeroCommenti}",
                    style: const TextStyle(fontSize: 16)),
                Text(
                  "Condivisioni: ${recipesState.recipeInteraction!.numeroCondivisioni}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            spazio,
            const Text("PASSAGGI DELLA RICETTA",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            spazio,
            for (var i = 0; i < recipesState.passaggi.length; i++)
              StepViewComponents(
                stepIndex: i,
                testo: recipesState.passaggi[i],
                immagineUrl: recipesState.linkStepImages![i],
                key: UniqueKey(),
              ),
            spazio,
            const Text("RECENSIONI",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            spazio,
            if (!isMine)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: AddCommentComponent(
                  recipesState: recipesState,
                ),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView(
                padding: const EdgeInsets.all(defaultPadding),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  for (var i = 0;
                      i < recipesState.recipeInteraction!.commenti!.length;
                      i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                          vertical: defaultPadding),
                      child: CommentCard(
                          recipesState.recipeInteraction!.commenti![i]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
