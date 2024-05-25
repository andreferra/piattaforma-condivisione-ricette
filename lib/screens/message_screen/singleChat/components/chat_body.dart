import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/model/Message.dart';
import 'package:condivisionericette/utils/message/message_card.dart';
import 'package:condivisionericette/utils/message/recipe_card.dart';
import 'package:flutter/material.dart';

class ChatBody extends StatefulWidget {
  final String user1;
  final String user2;

  const ChatBody(this.user1, this.user2, {super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("messaggi").where(
        "id",
        whereIn: [
          "${widget.user1}-${widget.user2}",
          "${widget.user2}-${widget.user1}"
        ],
      ).snapshots(includeMetadataChanges: true),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Errore durante il caricamento dei messaggi"),
          );
        }
        if (snapshot.data!.docs[0]['messaggi'].isEmpty) {
          return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const Center(
                  child: Text("Nessun messaggio presente"),
                )
              ]);
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: snapshot.data!.docs[0]['messaggi'].length,
            itemBuilder: (context, index) {
              MessageType type = MessageType
                  .values[snapshot.data!.docs[0]['messaggi'][index]['type']];
              switch (type) {
                case MessageType.text:
                  return MessageCard(
                      Message.fromJson(
                          snapshot.data!.docs[0]['messaggi'][index]),
                      widget.user1);
                case MessageType.image:
                  return MessageCard(
                      Message.fromJson(
                          snapshot.data!.docs[0]['messaggi'][index]),
                      widget.user1);
                case MessageType.recipe:
                  return RecipeCard(
                    widget.user1,
                    Message.fromJson(snapshot.data!.docs[0]['messaggi'][index]),
                  );
                default:
                  return const SizedBox();
              }
            },
          ),
        );
      },
    );
  }
}
