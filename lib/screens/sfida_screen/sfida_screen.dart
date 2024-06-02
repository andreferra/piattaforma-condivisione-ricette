// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/recipes/add_recipes/add_recipes_screen.dart';
import 'package:condivisionericette/screens/sfida_screen/components/header_sfida.dart';
import 'package:condivisionericette/screens/sfida_screen/components/sfida_info.dart';
import 'package:condivisionericette/screens/sfida_screen/components/sfida_ricetta_info.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';

class SfidaScreen extends StatefulWidget {
  final Sfidegame sfide;
  final AuthUser user;
  const SfidaScreen({super.key, required this.sfide, required this.user});

  @override
  State<SfidaScreen> createState() => _SfidaScreenState();
}

class _SfidaScreenState extends State<SfidaScreen> {
  Sfidegame get sfide => widget.sfide;
  AuthUser get user => widget.user;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  Future<String> _handlerIscrizione() async {
    try {
      String res = 'error';
      await _firebaseRepository
          .iscriviUserSfida(user.uid, sfide.id)
          .then((value) {
        res = value;
      });
      return res;
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(sfide.name),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const HeaderSfida(),
              SfidaInfo(sfide: sfide),
              const SizedBox(height: 20),
              if (!sfide.utentiPartecipanti.contains(user.uid))
                AnimatedButton(
                  onTap: () async {
                    await _handlerIscrizione().then((value) {
                      if (value == 'error') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Errore durante l\'iscrizione'),
                          ),
                        );
                      } else {
                        setState(() {
                          sfide.utentiPartecipanti.add(user.uid);
                          sfide.partecipanti = sfide.partecipanti + 1;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Iscrizione avvenuta con successo, inizia a competere!'),
                          ),
                        );
                      }
                    });
                  },
                  child: const RoundedButtonStyle(
                    title: 'Partecipa',
                    bgColor: Colors.redAccent,
                  ),
                ),
              const Divider(
                height: 40,
                thickness: 2,
              ),
              SfidaRicettaInfo(sfide: sfide),
              const SizedBox(height: 20),
              if (sfide.utentiPartecipanti.contains(user.uid))
                Column(
                  children: [
                    const Text("Inizia subito a pubblicare la tua ricetta!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    AnimatedButton(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AddRecipesScreen(
                              sfida: true,
                              sfidaId: sfide.id,
                              ingredienti: sfide.ingredienti!,
                            ),
                          ),
                        );
                      },
                      child: const RoundedButtonStyle(
                        title: 'Pubblica la tua ricetta',
                        bgColor: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}
