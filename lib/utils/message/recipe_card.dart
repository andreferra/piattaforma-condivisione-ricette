// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/src/Message.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/view_recipe_screen.dart';
import 'package:condivisionericette/widget/recipe_card.dart';

class RecipeCard extends StatefulWidget {
  final String mioId;
  final Message message;
  const RecipeCard(this.mioId, this.message, {super.key});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  Stream<DocumentSnapshot>? recipeStream;

  @override
  void initState() {
    super.initState();
    recipeStream = _firebaseRepository.streamRecipe(widget.message.message);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: recipeStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final recipe = snapshot.data!;
          return Align(
            alignment: widget.message.senderId == widget.mioId
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: widget.message.senderId == widget.mioId
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: widget.message.senderId == widget.mioId
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    onTap: () {
                      _firebaseRepository.updateVisualizations(recipe.id);

                      bool isMine = widget.mioId == recipe['user_id'];

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewRecipeScreen(
                              visualizzazioni:
                                  recipe['numero_visualizzazioni'] + 1,
                              mioId: widget.mioId,
                              isMine: isMine,
                              recipesState:
                                  RecipesState.fromSnapshot(recipe))));
                    },
                    child: RecipeListItem(
                      imageUrl: recipe['cover_image'],
                      title: recipe['nome_piatto'],
                      description: recipe['descrizione'],
                      numeroLike: recipe['numero_like'].toString(),
                      numeroCommenti: recipe['numero_commenti'].toString(),
                      numeroCondivisioni:
                          recipe['numero_condivisioni'].toString(),
                      visualizzazioni:
                          recipe['numero_visualizzazioni'].toString(),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: widget.message.senderId == widget.mioId
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      widget.message.timestamp
                          .toDate()
                          .toString()
                          .substring(11, 16),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      widget.message.senderId == widget.mioId
                          ? Icons.done_all
                          : Icons.done,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
