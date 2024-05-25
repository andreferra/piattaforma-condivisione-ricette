// Flutter imports:
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
// Project imports:
import 'package:condivisionericette/model/Message.dart';
import 'package:condivisionericette/screens/message_screen/singleChat/single_chat.dart';
import 'package:condivisionericette/utils/message/chat_card.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  final String mioID;

  const ChatList(this.mioID, {super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseRepository firebaseRepository = FirebaseRepository();

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('messaggi').snapshots(),
        builder: (context, snapshot) {
          List<DocumentSnapshot> chat = [];

          if (snapshot.hasError) {
            return const Text('Errore');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            String id1 = snapshot.data!.docs[i]['id'].toString().split('-')[0];
            String id2 = snapshot.data!.docs[i]['id'].toString().split('-')[1];

            if (id1 == mioID || id2 == mioID) {
              chat.add(snapshot.data!.docs[i]);
            }
          }
          if (chat.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: chat.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await firebaseRepository
                        .setAllMessagesAsRead(
                            chat[index]['id'].toString().split('-')[0] == mioID
                                ? chat[index]['id'].toString().split('-')[1]
                                : chat[index]['id'].toString().split('-')[0],
                            mioID)
                        .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleChatScreen(
                                    chat[index]['id']
                                                .toString()
                                                .split('-')[0] ==
                                            mioID
                                        ? chat[index]['id']
                                            .toString()
                                            .split('-')[1]
                                        : chat[index]['id']
                                            .toString()
                                            .split('-')[0],
                                    mioID),
                              ),
                            ));
                  },
                  child: ChatCard(
                    mioID,
                    chat[index]['id'].toString().split('-')[0] == mioID
                        ? chat[index]['id'].toString().split('-')[1]
                        : chat[index]['id'].toString().split('-')[0],
                    Message.fromJson(chat[index]['messaggi']
                        [chat[index]['messaggi'].length - 1]),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
