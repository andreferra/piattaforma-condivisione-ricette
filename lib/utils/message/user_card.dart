import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/model/Message.dart';
import 'package:condivisionericette/screens/public_profile/public_profile_screen.dart';
import 'package:condivisionericette/screens/search_screen/components/user_card.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';

class UserCardChat extends StatefulWidget {
  final String mioId;
  final Message message;
  const UserCardChat(this.message, this.mioId, {super.key});

  @override
  State<UserCardChat> createState() => _UserCardChatState();
}

class _UserCardChatState extends State<UserCardChat> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  Stream<DocumentSnapshot>? recipeStream;

  @override
  void initState() {
    recipeStream = _firebaseRepository.streamUser(widget.message.message);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: recipeStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data!;
          return Align(
            alignment: widget.message.senderId == widget.mioId
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: widget.message.senderId == widget.mioId
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    color: widget.message.senderId == widget.mioId
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: UserCard(
                    function: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PublicProfile(
                                user.id,
                                widget.mioId,
                              )));
                    },
                    nickname: user['nickname'],
                    photoURL: user['photoURL'],
                    userID: user.id,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: widget.message.senderId == widget.mioId
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      widget.message.timestamp
                          .toDate()
                          .toString()
                          .substring(11, 16),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      widget.message.senderId == widget.mioId
                          ? Icons.done_all
                          : Icons.done,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
