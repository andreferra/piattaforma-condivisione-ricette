import 'package:condivisionericette/widget/text_input_field.dart';
import "package:flutter/material.dart";
import 'package:condivisionericette/screens/authentication/login_screen/controller/login_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class EmailField extends ConsumerWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final bool showError = loginState.email.invalid;
    final loginController = ref.read(loginProvider.notifier);
    return TextInputField(
      keyboardType: TextInputType.emailAddress,
      autofillHints: AutofillHints.email,
      hintText: "Inserisci l'indirizzo email",
      errorText: showError
          ? Email.showEmailErrorMessage(loginState.email.error)
          : null,
      onChanged: (email) => loginController.onEmailChanged(email),
    );
  }
}
