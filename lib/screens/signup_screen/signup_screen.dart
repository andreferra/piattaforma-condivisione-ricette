import 'package:condivisionericette/backend/AuthMethod.dart';
import 'package:condivisionericette/screens/home_screen/home_screen.dart';
import 'package:condivisionericette/screens/render_view.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/utils/function.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _numeroTelefonoController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomeController.dispose();
    _nicknameController.dispose();
    _numeroTelefonoController.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    try {
      final isValid = _formKey1.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        setState(() {
          _isLoading = true;
        });
        _formKey1.currentState!.save();
        await AuthMethod()
            .signUpWithEmailAndPassword(
                _emailController.text,
                _passwordController.text,
                _nomeController.text,
                _nicknameController.text,
                _numeroTelefonoController.text)
            .then((value) {
          if (value == "ok") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RenderScreen(
                        child: widgetList[0],
                      )),
            );
          } else {
            setState(() {
              _isLoading = false;
            });
            showErrorSnackbar(context, "Errore nella registrazione: $value");
          }
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if(mounted) {
        showErrorSnackbar(context, e.toString());
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? buildLoadingIndicator()
            : Row(
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
                              key: _formKey1,
                              child: Column(
                                children: [
                                  formInserimento("Nome", TextInputType.text,
                                      (p0) => _checkNome(p0), _nomeController),
                                  spacer(0, 20),
                                  formInserimento(
                                      "Nickname",
                                      TextInputType.text,
                                      (p0) => _checkNome(p0),
                                      _nicknameController),
                                  spacer(0, 20),
                                  formInserimento(
                                    "Email",
                                    TextInputType.emailAddress,
                                    (p0) => _checkEmail(p0),
                                    _emailController,
                                  ),
                                  spacer(0, 20),
                                  formInserimento(
                                      "Numero di telefono",
                                      TextInputType.phone,
                                      (p0) => _checkNumeroTelefono(p0),
                                      _numeroTelefonoController),
                                  spacer(0, 20),
                                  formInserimento(
                                      "Password",
                                      TextInputType.visiblePassword,
                                      (p0) => _checkPassword(p0),
                                      _passwordController),
                                  spacer(0, 30),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
