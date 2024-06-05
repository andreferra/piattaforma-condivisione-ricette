// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';

class RecipeSfide extends StatefulWidget {
  final Recipesfide newRecipe;
  final AuthUser user;
  const RecipeSfide({super.key, required this.newRecipe, required this.user});

  @override
  State<RecipeSfide> createState() => _RecipeSfideState();
}

class _RecipeSfideState extends State<RecipeSfide> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  Recipesfide recipe = Recipesfide.empty();
  AuthUser get user => widget.user;
  late bool isMine;
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    recipe = widget.newRecipe;
    isMine = recipe.userID == user.uid;
    isLiked = recipe.votiPositivi.contains(user.uid);
    isDisliked = recipe.votiNegativi.contains(user.uid);
    super.initState();
  }

  void _handlerLike() async {
    setState(() {
      isLiked = !isLiked;
      isDisliked = false;
      _updateRecipe();
    });
  }

  void _handlerDislike() {
    setState(() {
      isDisliked = !isDisliked;
      isLiked = false;
    });
    _updateRecipe();
  }

  void _updateRecipe() async {
    recipe.votiPositivi.remove(user.uid);
    recipe.votiNegativi.remove(user.uid);

    if (isLiked) {
      recipe.votiPositivi.add(user.uid);
    } else if (isDisliked) {
      recipe.votiNegativi.add(user.uid);
    }

    await _firebaseRepository.updateRecipeSfide(recipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.nomePiatto.toUpperCase()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    recipe.coverImage,
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.fastfood),
                          const SizedBox(width: 8),
                          Text(
                            recipe.nomePiatto,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                      fontSize: 24,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.people),
                          const SizedBox(width: 8),
                          Text(
                            'Porzioni: ${recipe.porzioni}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white60,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.timer),
                          const SizedBox(width: 8),
                          Text(
                            'Tempo di preparazione: ${recipe.tempoPreparazione} minuti',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white60,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    recipe.descrizione,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.blueGrey,
                          fontSize: 18,
                        ),
                  ),
                )
              ],
            ),
            if (recipe.ingredienti.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Ingredienti:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.ingredienti.join(', '),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white60,
                        ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (recipe.passaggi.isNotEmpty &&
                recipe.immaginiPassaggi.isNotEmpty)
              for (int i = 0; i < recipe.passaggi.length; i++)
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF95A3A4),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Passaggio ${i + 1}:',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 22,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                recipe.immaginiPassaggi[i],
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  recipe.passaggi[i],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "PARTECIPA ANCHE TU ALLA SFIDA!",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            Center(
              child: Text(
                "VOTA LA RICETTA!",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            if (!isMine)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                        color: Colors.green),
                    onPressed: () {
                      _handlerLike();
                    },
                  ),
                  Text(
                    '${recipe.votiPositivi.length}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                        isDisliked
                            ? Icons.thumb_down
                            : Icons.thumb_down_alt_outlined,
                        color: Colors.red),
                    onPressed: () {
                      _handlerDislike();
                    },
                  ),
                  Text(
                    '${recipe.votiNegativi.length}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black87,
                        ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (isMine)
              Column(
                children: [
                  Text(
                    'Totale voti: ${recipe.votiNegativi.length + recipe.votiPositivi.length}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black87,
                        ),
                  ),
                  Text(
                    'Voti positivi: ${recipe.votiPositivi.length}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.green,
                        ),
                  ),
                  Text(
                    'Voti negativi: ${recipe.votiNegativi.length}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.red,
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
