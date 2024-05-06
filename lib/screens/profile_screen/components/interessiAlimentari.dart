import 'package:condivisionericette/screens/profile_screen/controller/profile_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

class InteressiAlimentari extends ConsumerWidget {
  const InteressiAlimentari({super.key, required this.valoreIniziale});

  final List<String> valoreIniziale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final showError = profileState.interesseCulinario!.invalid;
    final profileController = ref.read(profileProvider.notifier);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextInputField(
                hintText: "Inserisci un interesse culinario*",
                errorText: showError
                    ? InteressiCulinari.showInteressiCulinariErrorMessage(
                    profileState.interesseCulinario!.error)
                    : null,
                onChanged: (allergeni) =>
                    profileController.checkInteresseCulinario(allergeni),
              ),
            ),
            AnimatedButton(
                onTap: () {
                  profileController
                      .onNewInteresseCulinarioChanged(profileState.interesseCulinario!.value,
                      valoreIniziale);
                },
                child: const RoundedButtonStyle(
                  title: "Aggiungi",
                  orizzontalePadding: 18,
                  verticalePadding: 12,
                )),
          ],
        ),
        spacer(0, 10),
        Wrap(
          spacing: 10,
          children: valoreIniziale
              .map((interesseCulinario) => Chip(
            label: Text(interesseCulinario),
            onDeleted: () {
              profileController.removeInteresseCulinario(interesseCulinario, valoreIniziale);
            },
          ))
              .toList(),
        ),
      ],
    );
  }
}
