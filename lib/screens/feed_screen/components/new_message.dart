// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model_repo/src/Message.dart';

class NewMessage extends StatefulWidget {
  final String userID;
  const NewMessage({super.key, required this.userID});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String get userId => widget.userID;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('messaggi').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Icon(Icons.error);
          }
          if (snapshot.hasData) {
            List<Message> chat = [];

            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              String id1 =
                  snapshot.data!.docs[i]['id'].toString().split('-')[0];
              String id2 =
                  snapshot.data!.docs[i]['id'].toString().split('-')[1];
              if (id1 == userId || id2 == userId) {
                chat.add(
                    Message.fromJson(snapshot.data!.docs[i]['messaggi'][0]));
              }
            }

            if (chat.isEmpty) {
              return const Icon(Icons.messenger_outline_outlined);
            }
            List<Message> unreadMessages = chat
                .where((element) =>
                    element.isRead == false && element.receiverId == userId)
                .toList();

            if (unreadMessages.isNotEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.message_outlined),
                  const SizedBox(height: 5),
                  Text(
                    unreadMessages.length == 1
                        ? "${unreadMessages.length} nuovo messaggio"
                        : "${unreadMessages.length} nuovi messaggi",
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
            return const Icon(Icons.messenger_outline_outlined);
          }
          return const Icon(Icons.messenger_outline_outlined);
        },
      ),
    );
  }
}
