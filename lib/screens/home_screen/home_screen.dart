import 'package:condivisionericette/screens/signup_screen/signup_screen.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    debugPrint("email: $_email");
    debugPrint("password:  $_password");
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  _checkPassword(String password) {
    return "Please enter a valid password.";
  }

  _checkEmail(String email) {
    if (email == '' || email.isEmpty || !email.contains('@')) {
      return 'Please enter a valid email address.';
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
                  "Welcome to RecipeBuddy",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                spacer(0, 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.18,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        formInserimento(
                          "Email",
                          TextInputType.emailAddress,
                          (p0) => _checkEmail(p0),
                          (p0) => _saveEmail(p0),
                        ),
                        spacer(0, 20),
                        formInserimento(
                            "Password",
                            TextInputType.visiblePassword,
                            (p0) => _checkPassword(p0),
                            (p0) => _savePassword(p0)),
                        spacer(0, 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                  "Login",
                                  style: TextStyle(fontSize: 16),
                                )),
                            spacer(30, 0),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 18),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 16),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            spacer(100, 0),
            Image.asset(
              "assets/illustration/home.png",
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ]),
        ),
      ],
    ));
  }
}
