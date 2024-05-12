import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/setting_screen/controller/setting_controller.dart';
import 'package:condivisionericette/widget/button/animated_button.dart';
import 'package:condivisionericette/widget/button/rounded_button_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAccount extends ConsumerWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final settingController = ref.read(settingProvider.notifier);
    final authController = ref.read(authProvider.notifier);
    final uid = ref.watch(authProvider).user.uid;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.48,
      child: Column(
        children: [
          const Text(
            "Elimina account",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Elimina definitivamente il tuo account. Verranno eliminati tutti i tuoi dati e non potrai più recuperarli. Verranno eliminate anche tutte le ricette e le foto che hai pubblicato. Questa azione è irreversibile.",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          AnimatedButton(
            onTap: () {
              settingController.deleteAccount(uid);
              authController.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: RoundedButtonStyle(
              title: "Elimina account",
              bgColor: Colors.red.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
