// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_repo/auth_repo.dart';

// Project imports:
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';

class RecuperoPWD extends StatefulWidget {
  const RecuperoPWD({super.key});

  @override
  _RecuperoPWDState createState() => _RecuperoPWDState();
}

class _RecuperoPWDState extends State<RecuperoPWD> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
                        }
                        return null;
                      },
                    ),
                    spacer(0, 20),
                    AnimatedButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await _sendPasswordResetEmail(
                                _emailController.text);
                          }
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

  Future<void> _sendPasswordResetEmail(String email) async {
    try {
      AuthenticationRepository authRepo = AuthenticationRepository();
      await authRepo.forgotPassword(email: email).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email di recupero password inviata')));

        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'invio dell\'email')),
      );
    }
  }
}
