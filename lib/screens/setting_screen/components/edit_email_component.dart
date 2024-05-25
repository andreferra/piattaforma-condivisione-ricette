// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/screens/setting_screen/controller/setting_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';

class EditEmail extends ConsumerWidget {
  const EditEmail({super.key, required this.valoreInziale});

  final String valoreInziale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingController = ref.read(settingProvider.notifier);
    final settingState = ref.watch(settingProvider);
    final showError = settingState.newEmail!.invalid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextInputField(
            testoSopra: "Cambia Email",
            hintText: 'Email',
            valoreIniziale: valoreInziale,
            errorText: showError
                ? Email.showEmailErrorMessage(settingState.newEmail!.error)
                : null,
            onChanged: (value) {
              settingController.onNewEmailChanged(value);
            },
          ),
        )
      ],
    );
  }
}
