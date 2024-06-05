// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// Project imports:
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/model/Notification.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/loading_errors.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:model_repo/model_repo.dart';
import 'package:uuid/uuid.dart';

class ReceptsStep extends ConsumerWidget {
  final bool sfida;
  final String sfidaId;
  final List<String> ingredienti;
  final List<String> urlImmagini;
  final SfideType type;
  const ReceptsStep(
      {super.key,
      required this.sfida,
      required this.sfidaId,
      this.type = SfideType.none,
      this.urlImmagini = const [],
      this.ingredienti = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(addRecipesProvider, (previous, current) {
      if (current.errorType == ErrorType.stepImage) {
        SnackBar snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.all(defaultPadding * 3),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            title: "Errore!",
            inMaterialBanner: true,
            message: current.errorMessage.toString(),
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        ref.read(addRecipesProvider.notifier).resetError();
      } else if (current.errorType == ErrorType.stepText) {
        SnackBar snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.all(defaultPadding * 3),
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            title: "Errore!",
            inMaterialBanner: true,
            message: current.errorMessage.toString(),
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        ref.read(addRecipesProvider.notifier).resetError();
      }
      if (current.status == StateRecipes.inProgress) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        LoadingSheet.show(context);
      }
    });

    final recipesController = ref.watch(addRecipesProvider.notifier);
    final recipesState = ref.watch(addRecipesProvider);
    final stepImage = recipesState.stepImage;
    final loadState = ref.watch(addRecipesProvider).status;
    final user = ref.watch(authProvider).user;
    final pageController = ref.watch(pageControllerProvider);
    return Column(
      children: [
        const SizedBox(
          height: defaultPadding * 3,
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: Row(
            children: [
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
                String res = recipesController.addStep();
                if (res == "ok") {
                  SnackBar snackBar = SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    content: AwesomeSnackbarContent(
                      title: "Step aggiunto",
                      message: "Lo step è stato aggiunto con successo",
                      contentType: ContentType.success,
                    ),
                    duration: const Duration(seconds: 2),
                    padding: const EdgeInsets.all(defaultPadding * 3),
                  );
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                }
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
                        fontSize: 22,
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
                    Expanded(
                      child: Text(
                        recipesState.passaggi[i],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
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
                    List<Map<String, dynamic>> notificheDaInviare = [];
                    if (user.follower!.isNotEmpty) {
                      for (var utenti in user.follower!) {
                        NotificationModel notification = NotificationModel(
                          notificationId: const Uuid().v4(),
                          title: "Nuova ricetta",
                          body:
                              "${user.nickname} ha pubblicato una nuova ricetta 🍽️",
                          type: NotificationType.newRecipe,
                          read: false,
                          extraData: "",
                          date: DateTime.now().toString(),
                          userSender: user.uid,
                          userReceiver: utenti,
                        );

                        notificheDaInviare.add(notification.toMap());
                      }
                    }

                    await recipesController.addMultiNotification(
                        notificheDaInviare, user.follower!);

                    await recipesController
                        .addRecipes(user, sfida, sfidaId, ingredienti)
                        .then(
                      (value) {
                        if (value == "ok") {
                          Navigator.of(context).pop();
                          SnackBar snackBar = SnackBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: AwesomeSnackbarContent(
                              title: "Ricetta pubblicata",
                              message:
                                  "La tua ricetta è stata pubblicata con successo",
                              contentType: ContentType.success,
                            ),
                            duration: const Duration(seconds: 2),
                            padding: const EdgeInsets.all(defaultPadding * 3),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                          if (sfida) {
                            print("sfida");

                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          } else if (!sfida) {
                            pageController.setPage(1);
                          }
                        } else if (value == "error") {
                          recipesController.resetError();
                          SnackBar snackBar = SnackBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: AwesomeSnackbarContent(
                              title: "Errore",
                              message:
                                  "Errore pubblicazione della ricetta, controlla di aver compilato tutti i campi",
                              contentType: ContentType.failure,
                            ),
                            duration: const Duration(seconds: 5),
                            padding: const EdgeInsets.all(defaultPadding * 3),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                      },
                    );
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
