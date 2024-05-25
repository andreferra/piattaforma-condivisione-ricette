// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validator.dart';

// Project imports:
import 'package:condivisionericette/screens/profile_screen/controller/profile_controller.dart';
import 'package:condivisionericette/utils/utils.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:condivisionericette/widget/text_input_field.dart';

class AllergeniField extends ConsumerWidget {
  const AllergeniField({super.key, required this.valoreIniziale});

  final List<String> valoreIniziale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final showError = profileState.allergeno!.invalid;
    final profileController = ref.read(profileProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextInputField(
                hintText: "Inserisci un allergeno*",
                errorText: showError
                    ? Allergeni.showAllergeniErrorMessage(
                        profileState.allergeno!.error)
                    : null,
                onChanged: (allergeni) =>
                    profileController.checkAllergeno(allergeni),
              ),
            ),
            AnimatedButton(
                onTap: () {
                  profileController
                      .onNewAllergenoChanged(profileState.allergeno!.value,
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
              .map((allergene) => Chip(
                    label: Text(allergene),
                    onDeleted: () {
                      profileController.removeAlergeno(allergene, valoreIniziale);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
