// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/profile_screen/controller/profile_controller.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';

class SaveProfile extends ConsumerWidget {
  const SaveProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final profileController = ref.read(profileProvider.notifier);
    //final isValidated = profileState.status.isValidated;
    return AnimatedButton(
      onTap: () => profileController.updateProfile(user),
      child: const RoundedButtonStyle(
        title: "Aggiorna profilo",
        orizzontalePadding: 25,
      ),
    );
  }
}
