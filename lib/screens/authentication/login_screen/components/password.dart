import 'package:condivisionericette/screens/authentication/login_screen/controller/login_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class PasswordField extends ConsumerWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(loginProvider);
    final bool showError = signInState.password.invalid;
    final loginController = ref.read(loginProvider.notifier);
    return TextInputField(
      minLines: 1,
      hintText: "Inserisci la Password*",
      obscureText: true,
      errorText: showError
          ? Password.showPasswordErrorMessage(signInState.password.error)
          : null,
      onChanged: (password) => loginController.onPasswordChanged(password),
    );
  }
}
