// Flutter imports:
// Project imports:
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';

class RecuperoPWD extends StatefulWidget {
  const RecuperoPWD({super.key});

  @override
  State<RecuperoPWD> createState() => _RecuperoPWDState();
}

class _RecuperoPWDState extends State<RecuperoPWD> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthenticationRepository authRepo = AuthenticationRepository();
  final FirebaseRepository firebaseRepo = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recupero Password'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/illustration/resetmail.png',
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              const Text(
                  ' Inserisci il tuo indirizzo email per ricevere un link per il recupero della password ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un\'email';
                        } else if (!isValidEmail(value)) {
                          return 'Inserisci un\'email valida';
                        }
                        return null;
                      },
                    ),
                    spacer(0, 20),
                    AnimatedButton(
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          await authRepo
                              .checkEmail(_emailController.text)
                              .then((value) async {
                            if (value == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Email non presente nel sistema'),
                                ),
                              );
                              return;
                            }
                            await authRepo
                                .resetPassword(_emailController.text)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email di recupero inviata'),
                                ),
                              );
                            }).catchError((e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Email non presente nel sistema'),
                                ),
                              );
                            });
                          });
                        },
                        child: const RoundedButtonStyle(
                          title: 'Invia email di recupero',
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }
}
