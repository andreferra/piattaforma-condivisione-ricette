// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_repo/auth_repo.dart';

class WaitingConfermation extends StatefulWidget {
  final String email;
  final String oldEmail;
  final String password;
  final String userid;
  const WaitingConfermation(
      {super.key,
      required this.email,
      required this.oldEmail,
      required this.password,
      required this.userid});

  @override
  State<WaitingConfermation> createState() => _WaitingConfermationState();
}

class _WaitingConfermationState extends State<WaitingConfermation> {
  String get email => widget.email;
  String get oldEmail => widget.oldEmail;
  String get password => widget.password;
  String get id => widget.userid;
  late Timer _timer;
  bool isEmailConfirmed = false;
  FirebaseRepository firebaseRepository = FirebaseRepository();

  @override
  void initState() {
    try {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        print(FirebaseAuth.instance.currentUser);
        if (FirebaseAuth.instance.currentUser == null) {
          print("Loggo nel timer");
          print(email);
          print(id);
          print(password);
          print("Riloggo l'utente");
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password)
              .then((value) async {
            print("Aggiorno i dati");
            await firebaseRepository
                .updateEmailAndPassword(email, password, id)
                .then((value) {
              Navigator.of(context).pop();
              timer.cancel();
            });
          }).catchError((e) {
            print(e);
          });
        } else {
          print("Loggo nel timer else");
          if (FirebaseAuth.instance.currentUser!.email == email) {
            await firebaseRepository
                .updateEmailAndPassword(id, email, password)
                .then((value) {
              Navigator.of(context).pop();
              timer.cancel();
            });
          }
          await FirebaseAuth.instance.currentUser!.reload();
        }
      });
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Errore: ${snapshot.error}");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (FirebaseAuth.instance.currentUser != null) {
              print(FirebaseAuth.instance.currentUser!.email);
              if (FirebaseAuth.instance.currentUser!.email == oldEmail) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      const Text("Conferma la nuova email"),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser!
                                  .verifyBeforeUpdateEmail(email);
                            },
                            child: const Text("Inavia email di conferma"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (FirebaseAuth.instance.currentUser!.email == email) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    const Text("Email confermata"),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Continua"),
                        ),
                      ],
                    ),
                  ],
                );
              }
            } else {
              print("Loggo nel builder");
              InkWell(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);
                    _timer.cancel();
                    await firebaseRepository
                        .updateEmailAndPassword(id, email, password)
                        .then(
                      (value) {
                        Navigator.of(context).pop();
                      },
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text("Prosegui"),
              );
            }

            return const CircularProgressIndicator(
              value: 100,
            );
          }),
    ));
  }
}
