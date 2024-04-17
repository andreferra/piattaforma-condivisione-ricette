import 'package:condivisionericette/screens/authentication/signup_screen/controller/signup_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class NameField extends ConsumerWidget {
  const NameField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final showError = signUpState.name.invalid;
    final signUpController = ref.read(signUpProvider.notifier);
    return TextInputField(
      hintText: 'Inserisci l\'Username*',
      errorText:
          showError ? Name.showNameErrorMessage(signUpState.name.error) : null,
      onChanged: (name) => signUpController.onNameChanged(name),
    );
  }
}
