// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/message_screen/singleChat/components/chat_body.dart';
import 'package:condivisionericette/screens/message_screen/singleChat/components/chat_header.dart';
import 'package:condivisionericette/screens/message_screen/singleChat/components/chat_input.dart';

class SingleChatScreen extends StatefulWidget {
  final String userID;
  final String mioId;

  const SingleChatScreen(this.userID, this.mioId, {super.key});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  bool isLoad = false;
  AuthUser user = AuthUser.empty;

  @override
  initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    await FirebaseRepository().getUserFromDatabase(widget.userID).then((user) {
      if (mounted) {
        setState(() {
          isLoad = true;
          this.user = user;
        });
      }
    });
    setState(() {
      isLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(user.nickname!.toUpperCase()),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ChatHeader(
                    widget.mioId,
                    user,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ChatBody(
                          user.uid,
                          widget.mioId,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ChatInput(widget.mioId, widget.userID),
                ),
              ],
            ))
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
