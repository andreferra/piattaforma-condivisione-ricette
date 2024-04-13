import 'package:condivisionericette/screens/home_screen/home_screen.dart';
import 'package:condivisionericette/utils/function.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _nome = '';
  String _nickname = '';
  String _numeroTelefono = '';

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    debugPrint("email: $_email");
    debugPrint("password:  $_password");
    debugPrint("nome: $_nome");
    debugPrint("nickname: $_nickname");
    debugPrint("numeroTelefono: $_numeroTelefono");
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  _checkPassword(String password) {
    return checkPassword(password);
  }

  _checkEmail(String email) {
    if (email == '' || email.isEmpty || !email.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  _checkNumeroTelefono(String numeroTelefono) {
    return checkNumeroTelefono(numeroTelefono);
  }

  _checkNome(String nome) {
    if (nome == '' || nome.isEmpty) {
      return 'Please enter a valid name.';
    }
    return null;
  }

  _saveEmail(String email) {
    _email = email;
  }

  _savePassword(String password) {
    _password = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        spaceCenter(1),
        Expanded(
          flex: 2,
          child: Row(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "SignUp to RecipeBuddy",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        formInserimento("Nome", TextInputType.text,
                            (p0) => _checkNome(p0), (p0) => _nome = p0),
                        spacer(0, 20),
                        formInserimento("Nickname", TextInputType.text,
                            (p0) => _checkNome(p0), (p0) => _nickname = p0),
                        spacer(0, 20),
                        formInserimento(
                          "Email",
                          TextInputType.emailAddress,
                          (p0) => _checkEmail(p0),
                          (p0) => _saveEmail(p0),
                        ),
                        spacer(0, 20),
                        formInserimento(
                            "Numero di telefono",
                            TextInputType.phone,
                            (p0) => _checkNumeroTelefono(p0),
                            (p0) => _numeroTelefono = p0),
                        spacer(0, 20),
                        formInserimento(
                            "Password",
                            TextInputType.visiblePassword,
                            (p0) => _checkPassword(p0),
                            (p0) => _savePassword(p0)),
                        spacer(0, 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: _trySubmit,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 18),
                                ),
                                child: const Text(
                                  "SignUp",
                                  style: TextStyle(fontSize: 16),
                                )),
                            spacer(30, 0),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 18),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            spacer(100, 0),
            Image.asset(
              "assets/illustration/signup.png",
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.6,
            )
          ]),
        ),
      ],
    ));
  }
}
