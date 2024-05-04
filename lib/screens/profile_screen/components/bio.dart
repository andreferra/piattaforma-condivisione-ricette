import 'package:condivisionericette/screens/profile_screen/controller/profile_controller.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class BioField extends ConsumerWidget {
  const BioField({super.key, required this.valoreIniziale});

  final String valoreIniziale;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final showError = profileState.newBio!.invalid;
    final profileController = ref.read(profileProvider.notifier);
    return TextInputField(
      minLines: 2,
      valoreIniziale: valoreIniziale,
      hintText: 'Inserisci una bio*',
      errorText: showError
          ? Bio.showBioErrorMessage(profileState.newBio!.error)
          : null,
      onChanged: (bio) => profileController.onNewBioChanged(bio),
    );
  }
}
