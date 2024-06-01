// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:model_repo/model_repo.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/loading_errors.dart';
import 'package:condivisionericette/widget/text_input_field.dart';

class AddNewChallenge extends StatefulWidget {
  const AddNewChallenge({super.key});

  @override
  State<AddNewChallenge> createState() => _AddNewChallengeState();
}

class _AddNewChallengeState extends State<AddNewChallenge> {
  final FirebaseRepository firebaseRepository = FirebaseRepository();
  Sfidegame sfideGame = Sfidegame.empty();
  SfideType sfideType = SfideType.none;
  String error = '';

  @override
  void initState() {
    sfideGame = sfideGame.copyWith(
      id: const Uuid().v4(),
      punti: 500,
      partecipanti: 0,
      utentiPartecipanti: [],
      classifica: [],
      immagini: [],
      dataCreazione: DateTime.now(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text("Aggiungi una nuova sfida", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        TextInputField(
            hintText: "Aggiungi un titolo",
            onChanged: (value) {
              setState(() {
                sfideGame = sfideGame.copyWith(name: value);
              });
            }),
        const SizedBox(height: 10),
        TextInputField(
            hintText: "Aggiungi una descrizione",
            onChanged: (value) {
              setState(() {
                sfideGame = sfideGame.copyWith(description: value);
              });
            }),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              backgroundColor: secondaryColor.withOpacity(0.5),
              initialDisplayDate: DateTime.now(),
              monthViewSettings: const DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
              headerStyle: const DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: secondaryColor,
                textStyle: TextStyle(color: Colors.white),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  sfideGame = sfideGame.copyWith(
                      dataInizio: args.value.startDate,
                      dataFine: args.value.endDate);
                });
              }),
        ),
        DropdownButtonFormField<String>(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Seleziona il tipo di sfida",
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          padding: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(10),
          value: SfideType.values.indexOf(sfideType).toString(),
          onChanged: (value) {
            setState(() {
              sfideType = SfideType.values[int.parse(value!)];
              sfideGame = sfideGame.copyWith(type: sfideType);
            });
          },
          items: [
            DropdownMenuItem(
              value: SfideType.values.indexOf(SfideType.none).toString(),
              child: const Text("Seleziona il tipo di sfida"),
            ),
            DropdownMenuItem(
              value: SfideType.values.indexOf(SfideType.image).toString(),
              child: const Text("Sfida con immagini"),
            ),
            DropdownMenuItem(
                value:
                    SfideType.values.indexOf(SfideType.ingredients).toString(),
                child: const Text("Sfida con ingredienti")),
          ],
        ),
        if (sfideType == SfideType.ingredients)
          Column(
            children: [
              const SizedBox(height: 10),
              TextInputField(
                  hintText: "Aggiungi ingredienti separati da una virgola",
                  onChanged: (value) {
                    setState(() {
                      sfideGame = sfideGame.copyWith(
                          ingredienti:
                              value.split(",").map((e) => e.trim()).toList());
                    });
                  }),
              const SizedBox(height: 10),
              if (sfideGame.ingredienti != null)
                Wrap(
                  children: sfideGame.ingredienti!
                      .map((e) => Chip(
                            label: Text(e),
                            onDeleted: () {
                              setState(() {
                                sfideGame = sfideGame.copyWith(
                                    ingredienti: sfideGame.ingredienti!
                                      ..remove(e));
                              });
                            },
                          ))
                      .toList(),
                ),
            ],
          ),
        if (sfideType == SfideType.image)
          Column(
            children: [
              const Text("Aggiungi immagini"),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () async {
                      try {
                        final XFile? image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          Uint8List file = await image.readAsBytes();
                          setState(() {
                            sfideGame = sfideGame.copyWith(
                                immagini: [...sfideGame.immagini!, file]);
                          });

                          print(sfideGame.immagini!.length);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (sfideGame.immagini != null)
                    Wrap(
                      spacing: 20,
                      children: sfideGame.immagini!
                          .map((e) => Image.memory(
                                e,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              ))
                          .toList(),
                    ),
                ],
              ),
            ],
          ),
        const SizedBox(height: 10),
        if (error.isNotEmpty)
          Text(error, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 10),
        AnimatedButton(
            onTap: () {
              if (sfideGame.name.isEmpty ||
                  sfideGame.description.isEmpty ||
                  sfideGame.type == SfideType.none) {
                setState(() {
                  error = "Compila tutti i campi";
                });
                return;
              }

              try {
                firebaseRepository.addSfida(sfideGame).then((value) {
                  if (value.isEmpty) {
                    setState(() {
                      error = "Errore durante l'aggiunta della sfida";
                    });
                    return;
                  }
                  ErrorDialog.show(context, "Sfida aggiunta con successo");
                  setState(() {
                    sfideGame = Sfidegame.empty();
                    error = '';
                  });
                });
              } catch (e) {
                print(e);
              }
            },
            child: const RoundedButtonStyle(
              title: "AGGIUNGI SFIDA",
              bgColor: buttonBg,
            )),
      ],
    );
  }
}
