// Flutter imports:
// Project imports:
import 'package:condivisionericette/screens/authentication/login_screen/controller/login_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordField extends ConsumerWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(loginProvider);
    final bool showError = signInState.password.invalid;
    final loginController = ref.read(loginProvider.notifier);
    return TextInputField(
      autofillHints: AutofillHints.password,
      minLines: 1,
      hintText: "Inserisci la Password*",
      obscureText: true,
      errorText: null,
      onSubmitted: () => loginController.signInWithEmailAndPassword(),
      onChanged: (password) => loginController.onPasswordChanged(password),
    );
  }
}
