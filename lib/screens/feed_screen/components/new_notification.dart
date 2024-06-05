import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';

class NewNotification extends StatefulWidget {
  final String userId;
  const NewNotification({super.key, required this.userId});

  @override
  State<NewNotification> createState() => _NewNotificationState();
}

class _NewNotificationState extends State<NewNotification> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  String get userId => widget.userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.green[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder<AuthUser>(
        future: _firebaseRepository.getUserFromDatabase(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }
          print(snapshot.data);
          if (snapshot.hasData && snapshot.data!.newNotifiche!) {
            List<String> notifiche = snapshot.data!.listaNotifiche!;

            List<String> notificheNonLette = notifiche
                .where((element) => element.contains("read: false"))
                .toList();

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.notifications),
                const SizedBox(height: 5),
                Text(
                  notificheNonLette == 1
                      ? "${notificheNonLette.length} nuova notifica"
                      : "${notificheNonLette.length} nuove notifiche",
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          return const Icon(Icons.notifications_off_outlined);
        },
      ),
    );
  }
}
