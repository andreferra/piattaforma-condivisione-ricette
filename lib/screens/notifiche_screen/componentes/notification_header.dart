// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';

class NotificationHeader extends ConsumerWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseRepository firebaseRepository = FirebaseRepository();
    final user = ref.watch(authProvider).user;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              firebaseRepository.setAllNotificationRead(user.uid);
            },
            child: const Text('Segna come lette')),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            await firebaseRepository.deleteAllNotification(user.uid).then(
              (value) {
                if (value == 'ok') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifiche eliminate'),
                    ),
                  );
                }
              },
            );
          },
          child: const Text('Elimina tutto'),
        ),
      ],
    );
  }
}
