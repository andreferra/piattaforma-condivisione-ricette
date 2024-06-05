// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_repo/src/Notification.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/notifiche_screen/componentes/notification_card.dart';
import 'package:condivisionericette/screens/notifiche_screen/componentes/notification_header.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';

class NotificheScreen extends ConsumerWidget {
  const NotificheScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseRepository firebaseRepository = FirebaseRepository();
    final user = ref.watch(authProvider).user;

    Stream<List<NotificationModel>> getNotification() {
      return firebaseRepository.streamUser(user.uid)!.map((snapshot) {
        if (snapshot.exists) {
          List<dynamic> notification = snapshot['listaNotifiche'];
          return notification
              .map((element) => NotificationModel.fromMap(element))
              .toList();
        } else {
          return [];
        }
      });
    }

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const Header(),
          const SizedBox(height: defaultPadding),
          const NotificationHeader(),
          const SizedBox(height: defaultPadding),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: StreamBuilder<List<NotificationModel>>(
              stream: getNotification(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<NotificationModel>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return NotificationCard(snapshot.data![index]);
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
