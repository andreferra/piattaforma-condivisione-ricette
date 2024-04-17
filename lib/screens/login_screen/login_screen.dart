import 'package:condivisionericette/widget/loading_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

import 'package:condivisionericette/screens/login_screen/controller/login_controller.dart';
import 'package:condivisionericette/screens/login_screen/components/button.dart';
import 'package:condivisionericette/screens/login_screen/components/email.dart';
import 'package:condivisionericette/screens/login_screen/components/password.dart';
import 'package:condivisionericette/screens/signup_screen/signup_screen.dart';
import 'package:condivisionericette/utils/utils.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<LoginState>(loginProvider, (previus, current) {
      if (current.status.isSubmissionInProgress) {
        LoadingSheet.show(context);
      } else if (current.status.isSubmissionFailure) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "${current.errorMessage}");
      } else if (current.status.isSubmissionSuccess) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

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
                  child: Column(
                    children: [
                      const EmailField(),
                      spacer(0, 20),
                      const PasswordField(),
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
                          const LoginButton(),
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
