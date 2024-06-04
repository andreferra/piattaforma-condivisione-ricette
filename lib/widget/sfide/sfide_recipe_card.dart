import 'package:condivisionericette/screens/search_screen/components/user_card.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

class SfideRecipeCard extends StatefulWidget {
  final Recipesfide recipe;
  const SfideRecipeCard({super.key, required this.recipe});

  @override
  State<SfideRecipeCard> createState() => _SfideRecipeCardState();
}

class _SfideRecipeCardState extends State<SfideRecipeCard> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  Recipesfide get recipe => widget.recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              recipe.coverImage,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.nomePiatto.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(recipe.descrizione,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.blueGrey),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            FutureBuilder<AuthUser>(
                future: _firebaseRepository.getUserFromDatabase(recipe.userID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Errore durante il caricamento dell\'utente'),
                    );
                  }
                  if (snapshot.hasData) {
                    return UserCard(
                      function: () {},
                      nickname: snapshot.data!.nickname!,
                      userID: snapshot.data!.uid,
                      photoURL: snapshot.data!.photoURL!,
                    );
                  }
                  return const Center(
                    child: Text('Nessun utente trovato'),
                  );
                }),
            const SizedBox(height: 10),
            // TODO: add posizione in classifica
          ],
        ),
      ),
    );
  }
}
