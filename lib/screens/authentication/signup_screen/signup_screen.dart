// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/screens/authentication/login_screen/login_screen.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/button.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/email.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/name.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/nickname.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/password.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/components/phone.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/controller/signup_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/loading_errors.dart';

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
          ErrorDialog.show(context, "${curr.errorMessage}");
        } else if (curr.status.isSubmissionSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );

    double spaceVert = MediaQuery.of(context).size.height * 0.05;
    double spaceHor = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
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
                  spacer(0, spaceVert),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const NameField(),
                        spacer(0, spaceVert),
                        const NicknameField(),
                        spacer(0, spaceVert),
                        const EmailField(),
                        spacer(0, spaceVert),
                        const PhoneField(),
                        spacer(0, spaceVert),
                        const PasswordField(),
                        spacer(0, spaceVert),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SignUpButton(),
                            spacer(spaceHor, 0),
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
            ),
            spacer(100, 0),
            Image.asset(
              "assets/illustration/signup.png",
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.6,
            )
          ],
        ),
      ),
    );
  }
}
