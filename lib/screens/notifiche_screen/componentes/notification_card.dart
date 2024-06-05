// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/src/Notification.dart';

// Project imports:
import 'package:condivisionericette/widget/loading_errors.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  const NotificationCard(this.notification, {super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  final FirebaseRepository firebaseRepository = FirebaseRepository();
  late String differenzaTempo;
  late bool isRead;
  Timer? timer;

  String _calcolaTempoNotifica() {
    final DateTime now = DateTime.now();
    final DateTime dataNotifica = DateTime.parse(widget.notification.date!);
    final Duration difference = now.difference(dataNotifica);
    if (difference.inDays > 0) {
      return '${difference.inDays} giorni fa';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ore fa';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuti fa';
    } else {
      return '${difference.inSeconds} secondi fa';
    }
  }

  @override
  void initState() {
    isRead = widget.notification.read!;
    differenzaTempo = _calcolaTempoNotifica();
    timer = Timer.periodic(
        const Duration(minutes: 1),
        (Timer t) => setState(() {
              differenzaTempo = _calcolaTempoNotifica();
            }));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ).copyWith(
          side: BorderSide(
              color: isRead ? Colors.grey : Colors.blueAccent, width: 0.5)),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.notification.title!),
            subtitle: Text(widget.notification.body!),
            trailing: Text(differenzaTempo),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    try {
                      NotificationModel notification = widget.notification;
                      await firebaseRepository.updateNotificationRead(
                          widget.notification.notificationId!,
                          widget.notification.userReceiver!,
                          notification.copyWith(read: !isRead).toMap());
                      setState(() {
                        isRead = !isRead;
                      });
                    } catch (e) {
                      ErrorDialog.show(context, e.toString());
                    }
                  },
                  icon: isRead
                      ? const Icon(Icons.check)
                      : const Icon(Icons.check_box_outline_blank)),
              IconButton(
                onPressed: () async {
                  try {
                    await firebaseRepository.deleteNotificationById(
                        widget.notification.notificationId!,
                        widget.notification.userReceiver!);
                  } catch (e) {
                    ErrorDialog.show(context, e.toString());
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
