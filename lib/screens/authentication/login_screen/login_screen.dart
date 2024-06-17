// Flutter imports:
// Project imports:
import 'package:condivisionericette/screens/authentication/login_screen/components/button.dart';
import 'package:condivisionericette/screens/authentication/login_screen/components/email.dart';
import 'package:condivisionericette/screens/authentication/login_screen/components/password.dart';
import 'package:condivisionericette/screens/authentication/login_screen/controller/login_controller.dart';
import 'package:condivisionericette/screens/authentication/recuperoPWD/recupero_pwd_screen.dart';
import 'package:condivisionericette/screens/authentication/signup_screen/signup_screen.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/loading_errors.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<LoginState>(loginProvider, (previus, current) {
      if (current.status.isSubmissionInProgress) {
        LoadingSheet.show(context);
        if (current.errorMessage != null) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      } else if (current.status.isSubmissionFailure) {
        Navigator.of(context).pop();
        ErrorDialog.show(context, "${current.errorMessage}");
      } else if (current.status.isSubmissionSuccess) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    double spaceVert = MediaQuery.of(context).size.height * 0.05;
    double spaceHor = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              spacer(0, spaceVert),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const EmailField(),
                    spacer(0, spaceVert),
                    const PasswordField(),
                    spacer(0, 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RecuperoPWD()),
                            );
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    spacer(0, spaceVert),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const LoginButton(),
                        spacer(spaceHor, 0),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
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
          spacer(spaceHor, 0),
          Image.asset(
            "assets/illustration/home.png",
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
        ],
      ),
    ));
  }
}
