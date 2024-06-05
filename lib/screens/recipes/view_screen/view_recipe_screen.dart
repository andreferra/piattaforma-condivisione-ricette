// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:condivisionericette/model/Comment.dart';
import 'package:condivisionericette/model/Message.dart';
import 'package:condivisionericette/model/Notification.dart';
import 'package:condivisionericette/screens/public_profile/public_profile_screen.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/components/add_comment_component.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/utils/recipes/comment_view_components.dart';
import 'package:condivisionericette/utils/recipes/step_view_components.dart';
import 'package:condivisionericette/widget/share/share_screen.dart';

class ViewRecipeScreen extends StatefulWidget {
  final bool isMine;
  final String mioId;
  final RecipesState recipesState;
  final int? visualizzazioni;
  final int? mediaRecensioni;

  const ViewRecipeScreen({
    super.key,
    required this.recipesState,
    required this.isMine,
    required this.mioId,
    this.visualizzazioni,
    this.mediaRecensioni,
  });

  @override
  State<ViewRecipeScreen> createState() => _ViewRecipeScreenState();
}

class _ViewRecipeScreenState extends State<ViewRecipeScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  AuthUser user = AuthUser.empty;
  int numeroLike = 0;
  bool isLoad = false;
  bool isLike = false;

  Future<void> _handlerLike() async {
    try {
      NotificationModel notificationModel = NotificationModel(
        notificationId: const Uuid().v4(),
        title: "Nuovo Like",
        body:
            "Qualcuno ha messo like alla tua ricetta ${widget.recipesState.nomePiatto.toString().toUpperCase()} ❤️",
        date: DateTime.now().toString(),
        read: false,
        type: NotificationType.newLike,
        userSender: widget.mioId,
        userReceiver: widget.recipesState.userID,
        extraData: widget.recipesState.recipeID,
      );
      await _firebaseRepository
          .updateLike(
        widget.recipesState.recipeID!,
        widget.mioId,
        isLike,
        notificationModel.toMap(),
        widget.recipesState.userID!,
        user.gaming!,
        user.gameActive!,
      )
          .then(
        (value) {
          print(value);
          if (value == 'unlike') {
            setState(
              () {
                numeroLike = numeroLike - 1;
                isLike = false;
              },
            );
            return;
          } else if (value == 'like') {
            setState(
              () {
                numeroLike = numeroLike + 1;
                isLike = true;
              },
            );
            return;
          } else {
            print(value);
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _loadLike() async {
    try {
      await _firebaseRepository
          .getLikeList(widget.recipesState.recipeID!)
          .then((value) {
        if (value.isEmpty) {
          setState(() {
            isLike = false;
          });
        }
        for (var element in value) {
          if (element == widget.mioId) {
            setState(() {
              isLike = true;
            });
          }
        }

        setState(() {
          numeroLike = value.length;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void _loadUser() async {
    try {
      await _firebaseRepository
          .getUserFromDatabase(widget.recipesState.userID!)
          .then((value) {
        setState(() {
          user = value;
          isLoad = true;
        });
      });
    } catch (e) {
      print("Errore caricamento utente : ${e.toString()}");
    }
  }

  @override
  void initState() {
    _loadUser();
    _loadLike();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const spazio = SizedBox(height: defaultPadding * 2);

    return isLoad
        ? Scaffold(
            appBar: AppBar(
              title: Text(widget.recipesState.nomePiatto!.toUpperCase()),
              centerTitle: true,
              titleSpacing: 1,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.7),
              ),
              actions: [
                if (widget.isMine)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Elimina ricetta"),
                          content: const Text(
                              "Sei sicuro di voler eliminare la ricetta?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Annulla"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _firebaseRepository
                                    .deleteRecipe(widget.recipesState.recipeID!)
                                    .then((_) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                              },
                              child: const Text("Elimina"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  spazio,
                  Row(
                    children: [
                      if (widget.recipesState.linkCoverImage != null)
                        Expanded(
                          flex: 2,
                          child: Image.network(
                            widget.recipesState.linkCoverImage!,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ),
                      const SizedBox(width: defaultPadding * 4),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.recipesState.descrizione ?? "",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            spazio,
                            Text(
                                "Tempo di preparazione: ${widget.recipesState.tempoPreparazione} minuti",
                                style: const TextStyle(fontSize: 16)),
                            spazio,
                            Text("Porzioni: ${widget.recipesState.porzioni}",
                                style: const TextStyle(fontSize: 16)),
                            spazio,
                            Text(
                                "Difficoltà: ${widget.recipesState.difficolta}",
                                style: const TextStyle(fontSize: 16)),
                            spazio,
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PublicProfile(
                                          widget.recipesState.userID!,
                                          widget.mioId)));
                                },
                                child: Row(children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(user.photoURL!),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(user.nickname!),
                                      Text(widget.recipesState.dataCreazione!
                                          .toDate()
                                          .toString()
                                          .substring(0, 10)),
                                    ],
                                  )
                                ])),
                          ],
                        ),
                      ),
                      const SizedBox(width: defaultPadding * 4),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Ingredienti",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            for (var i = 0;
                                i < widget.recipesState.ingredienti.length;
                                i++)
                              Text(widget.recipesState.ingredienti[i],
                                  style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(width: defaultPadding * 4),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Allergie",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            for (var i = 0;
                                i < widget.recipesState.allergie.length;
                                i++)
                              Text(widget.recipesState.allergie[i],
                                  style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(width: defaultPadding * 4),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tag",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            for (var i = 0;
                                i < widget.recipesState.tag.length;
                                i++)
                              Text(widget.recipesState.tag[i],
                                  style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          "Visualizzazioni: ${widget.visualizzazioni ?? widget.recipesState.recipeInteraction!.visualizzazioni}",
                          style: const TextStyle(fontSize: 16)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade500,
                        ),
                        onPressed: () async {
                          await _handlerLike();
                        },
                        child: Row(
                          children: [
                            isLike
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                            const SizedBox(width: 8),
                            Text(
                              numeroLike.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                          "Commenti: ${widget.recipesState.recipeInteraction!.numeroCommenti}",
                          style: const TextStyle(fontSize: 16)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade500,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => ShareScreen(
                                        widget.mioId,
                                        widget.recipesState.recipeID!,
                                        MessageType.recipe,
                                      )));
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Condividi",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text("Media recensioni: ${widget.mediaRecensioni}",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  spazio,
                  const Text("PASSAGGI DELLA RICETTA",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  spazio,
                  for (var i = 0; i < widget.recipesState.passaggi.length; i++)
                    StepViewComponents(
                      stepIndex: i,
                      testo: widget.recipesState.passaggi[i],
                      immagineUrl: widget.recipesState.linkStepImages![i],
                      key: UniqueKey(),
                    ),
                  spazio,
                  const Text("RECENSIONI",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  spazio,
                  if (!widget.isMine)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: AddCommentComponent(
                        subComment: false,
                        title: "Lascia un commento alla ricetta",
                        recipesState: widget.recipesState,
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("recipes")
                            .where("uid",
                                isEqualTo: widget.recipesState.recipeID)
                            .snapshots(includeMetadataChanges: true),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Errore: ${snapshot.error}");
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text("Non ci sono commenti"));
                          }

                          if (snapshot.hasData) {
                            List<DocumentSnapshot> docs = snapshot.data!.docs;
                            return ListView.builder(
                              itemCount:
                                  snapshot.data!.docs[0]['commenti'].length,
                              itemBuilder: (context, index) {
                                return CommentCard(
                                  Comment.fromMap(docs[0]['commenti'][index]
                                      as Map<String, dynamic>),
                                  widget.recipesState,
                                  false,
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                  ),
                  const SizedBox(height: defaultPadding * 3),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
