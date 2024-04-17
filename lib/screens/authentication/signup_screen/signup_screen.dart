import 'package:condivisionericette/screens/authentication/login_screen/components/password.dart';
import 'package:condivisionericette/screens/authentication/login_screen/login_screen.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/button.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/email.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/name.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/nickname.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/controller/signup_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/loading_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignUpState>(
      signUpProvider,
      (prev, curr) {
        if (curr.status.isSubmissionInProgress) {
          LoadingSheet.show(context);
        } else if (curr.status.isSubmissionFailure) {
          Navigator.of(context).pop();
          ErrorDialog.show(context, "${curr.errorMessage}");
        } else if (curr.status.isSubmissionSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );

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
                  child: Column(
                    children: [
                      const NameField(),
                      spacer(0, 20),
                      const NicknameField(),
                      spacer(0, 20),
                      const EmailField(),
                      spacer(0, 20),
                      //inserire numero di telefono
                      spacer(0, 20),
                      const PasswordField(),
                      spacer(0, 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SignUpButton(),
                          spacer(30, 0),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
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
