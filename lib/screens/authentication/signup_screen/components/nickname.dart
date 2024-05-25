// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/screens/authentication/signup_screen/controller/signup_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';

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
      onChanged: (nickname) async {
        signUpController.onNicknameChanged(nickname);
      },
    );
  }
}
