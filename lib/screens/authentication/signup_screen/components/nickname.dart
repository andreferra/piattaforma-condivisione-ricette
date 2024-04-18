import 'package:condivisionericette/screens/authentication/signup_screen/controller/signup_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class NicknameField extends ConsumerWidget {
  const NicknameField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final showError = signUpState.nickname.invalid;
    final signUpController = ref.read(signUpProvider.notifier);
    return TextInputField(
      hintText: 'Inserisci un nickname*',
      errorText: showError
          ? Nickname.showNicknameErrorMessage(signUpState.nickname.error)
          : null,
      onChanged: (nickname) => signUpController.onNicknameChanged(nickname),
    );
  }
}
