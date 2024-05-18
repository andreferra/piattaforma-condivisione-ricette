import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/model/Comment.dart';
import 'package:condivisionericette/screens/public_profile/public_profile_screen.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/components/add_comment_component.dart';
import 'package:condivisionericette/screens/recipes/view_screen/controller/recipe_interaction_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerWidget {
  final Comment commento;
  final bool risposta;
  final RecipesState recipesState;

  const CommentCard(this.commento, this.recipesState, this.risposta,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reply = ref.watch(recipeInteractionProvider).reply;

    final recipeInteractionController =
        ref.read(recipeInteractionProvider.notifier);

    final userID = ref.watch(authProvider).user.uid;

    final commentoId =
        ref.watch(recipeInteractionProvider).idCommentoReply ?? "";

    return Card(
      margin: const EdgeInsets.all(defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PublicProfile(commento.userId!, userID)));
                  },
                  child: Row(children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(commento.urlUtente!),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(commento.nicknameUtente!),
                        Text(commento.dataCreazione!
                            .toDate()
                            .toString()
                            .substring(0, 10)),
                      ],
                    )
                  ]),
                ),
                if (commento.userId == ref.watch(authProvider).user.uid)
                  IconButton(
                      onPressed: () async {
                        await recipeInteractionController
                            .onDeleteComment(
                                commento.idCommento!, recipesState.recipeID!)
                            .then((value) {
                          switch (value) {
                            case "ok":
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Commento eliminato")));
                              break;
                            case "error":
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Errore durante l'eliminazione del commento")));
                              break;
                            default:
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Errore sconosciuto")));
                              break;
                          }
                        });
                      },
                      icon: const Icon(Icons.delete))
              ],
            ),
            const SizedBox(height: 8),
            const Text("Commento:"),
            const SizedBox(height: 8),
            Text(
              commento.commento!,
              textAlign: TextAlign.left,
              softWrap: true,
            ),
            const SizedBox(height: 8),
            //TODO: Add recipes photo
            if (commento.numeroStelle != 0 && risposta)
              Row(
                children: [
                  for (var i = 0; i < commento.numeroStelle!; i++)
                    const Icon(Icons.star, color: Colors.yellow, size: 20),
                ],
              ),
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.reply),
                    onPressed: () {
                      recipeInteractionController
                          .onReplyComment(commento.idCommento!);
                    }),
                const Text("Rispondi"),
              ],
            ),
            if (commentoId.isNotEmpty &&
                reply! &&
                commento.idCommento == commentoId)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AddCommentComponent(
                  subComment: true,
                  title: "Rispondi al commento",
                  recipesState: recipesState,
                ),
              ),
            if (commento.risposte != null && commento.risposte!.isNotEmpty)
              const Divider(
                thickness: 1,
                color: Colors.white,
              ),
            if (commento.risposte != null)
              for (var i = 0; i < commento.risposte!.length; i++)
                CommentCard(commento.risposte![i], recipesState, true),
          ],
        ),
      ),
    );
  }
}
