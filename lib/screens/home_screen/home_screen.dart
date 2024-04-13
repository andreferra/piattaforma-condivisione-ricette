import 'package:condivisionericette/backend/AuthMethod.dart';
import 'package:condivisionericette/screens/feed_screen/feed_screen.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _trySubmit() async {
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState!.save();
        await AuthMethod()
            .signInWithEmailAndPassword(
                _emailController.text, _passwordController.text)
            .then((value) {
          if (value == "ok") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedScreen(),
                ));
          } else {
            setState(() {
              _isLoading = false;
            });
            showErrorSnackbar(context, value);
          }
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showErrorSnackbar(context, e.toString());
    }
  }

  _checkPassword(String password) {
    if (password == '' || password.isEmpty) {
      return "Please enter a valid password.";
    }
  }

  _checkEmail(String email) {
    if (email == '' || email.isEmpty || !email.contains('@')) {
      return 'Please enter a valid email address.';
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
                                    _emailController,
                                  ),
                                  spacer(0, 20),
                                  formInserimento(
                                      "Password",
                                      TextInputType.visiblePassword,
                                      (p0) => _checkPassword(p0),
                                      _passwordController),
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
                                            "Login",
                                            style: TextStyle(fontSize: 16),
                                          )),
                                      spacer(30, 0),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignUpScreen()),
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
