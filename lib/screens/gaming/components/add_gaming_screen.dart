// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/gaming/controller/gaming_controller.dart';

class AddGamingScreen extends ConsumerWidget {
  const AddGamingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamingController = ref.watch(gamingProvider.notifier);
    final FirebaseRepository firebaseRepository = FirebaseRepository();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image:
                AssetImage('assets/illustration/gamification_explanation.png'),
            width: 250,
            height: 250,
          ),
          const SizedBox(height: 20),
          Text(
            'Sblocca nuove sfide ogni giorno!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          const Text(
            "Guadagna punti, sblocca badge e scala la classifica utilizzando la nostra app.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              try {
                gamingController.setGameActive(true);

                AuthUser user = ref.read(authProvider).user;

                ref
                    .watch(authProvider.notifier)
                    .onUserChanged(user.copyWith(gameActive: true));

                await gamingController.addGamingToUser(user.uid);
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Inizia a giocare!'),
          ),
        ],
      ),
    );
  }
}
