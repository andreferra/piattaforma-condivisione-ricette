import 'package:condivisionericette/screens/search_screen/components/user_card.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

class SfideMyRecipeCard extends StatefulWidget {
  final Recipesfide recipe;
  const SfideMyRecipeCard({super.key, required this.recipe});

  @override
  State<SfideMyRecipeCard> createState() => _SfideMyRecipeCardState();
}

class _SfideMyRecipeCardState extends State<SfideMyRecipeCard> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  Recipesfide get recipe => widget.recipe;
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      color: secondaryColor,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.network(
              recipe.coverImage,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(recipe.nomePiatto.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(recipe.descrizione,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer),
                      const SizedBox(width: 5),
                      Text('${recipe.tempoPreparazione} min'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.restaurant),
                      const SizedBox(width: 5),
                      Text('${recipe.porzioni} porzioni'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star),
                      const SizedBox(width: 5),
                      Text(
                          '${recipe.votiNegativi.length + recipe.votiPositivi.length} voti positivi'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<AuthUser>(
                      future: _firebaseRepository
                          .getUserFromDatabase(recipe.userID),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  snapshot.error.toString().split(':').last));
                        }
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator())
                            : UserCard(
                                function: () {},
                                nickname: snapshot.data!.nickname!,
                                userID: snapshot.data!.uid,
                                photoURL: snapshot.data!.photoURL!,
                              );
                      }),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye),
                      const SizedBox(width: 5),
                      Text('${recipe.visualizzazioni.length} visualizzazioni'),
                    ],
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
