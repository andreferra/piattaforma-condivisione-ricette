import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/model/Message.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatInput extends StatefulWidget {
  final String userId;
  final String mioId;

  const ChatInput(this.mioId, this.userId, {super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _sendMessage() async {
    try {
      if (_controller.text.isEmpty) {
        return "";
      }
      Message message = Message(
        senderId: widget.mioId,
        receiverId: widget.userId,
        message: _controller.text,
        timestamp: Timestamp.now(),
        isRead: false,
        id: const Uuid().v4(),
      );
      await _firebaseRepository.sendMessage(
        message.toJson(),
        widget.userId,
        widget.mioId,
      );
      return "ok";
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextInputField(
                hintText: "Scrivi un messaggio...",
                controller: _controller,
                onChanged: (value) {}),
          ),
          IconButton(
            onPressed: () async {
              await _sendMessage().then((value) {
                switch (value) {
                  case "":
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Inserisci un messaggio"),
                        ),
                      );
                      break;
                    }
                  default:
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Messaggio inviato"),
                        ),
                      );
                      _controller.clear();
                      break;
                    }
                }
              });
            },
            icon: const Icon(
              size: 30,
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
