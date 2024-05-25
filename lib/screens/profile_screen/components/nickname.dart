// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/screens/profile_screen/controller/profile_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';

class NicknameField extends ConsumerWidget {
  const NicknameField({super.key, required this.valoreIniziale});

  final String valoreIniziale;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final showError = profileState.newNickname!.invalid;
    final profileController = ref.read(profileProvider.notifier);
    return TextInputField(
      valoreIniziale: valoreIniziale,
      hintText: 'Inserisci un nickname*',
      errorText: showError
          ? Nickname.showNicknameErrorMessage(profileState.newNickname!.error)
          : null,
      onChanged: (nickname) => profileController.onNewNicknameChanged(nickname),
    );
  }
}
