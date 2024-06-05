// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// Project imports:
import 'package:model_repo/src/Message.dart';
import 'package:model_repo/src/Notification.dart';
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
  late Uint8List imageFile = Uint8List(0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _sendMessage() async {
    try {
      if (_controller.text.isEmpty && imageFile.isEmpty) {
        return "";
      }
      Message message = Message(
        senderId: widget.mioId,
        receiverId: widget.userId,
        message: _controller.text,
        timestamp: Timestamp.now(),
        isRead: false,
        id: const Uuid().v4(),
        type: imageFile.isEmpty ? MessageType.text : MessageType.image,
      );
      NotificationModel notificationModel = NotificationModel(
        notificationId: const Uuid().v4(),
        title: "Nuovo messaggio",
        body: "Hai ricevuto un nuovo messaggio  👀",
        date: DateTime.now().toString(),
        userSender: widget.mioId,
        userReceiver: widget.userId,
        type: NotificationType.newMessage,
        extraData: _controller.text,
        read: false,
      );
      await _firebaseRepository
          .sendMessage(
        message.toJson(),
        widget.userId,
        widget.mioId,
        imageFile.isEmpty ? "text" : "image",
        imageFile,
        notificationModel,
      )
          .then(
        (value) {
          if (imageFile.isNotEmpty) {
            setState(
              () {
                imageFile = Uint8List(0);
              },
            );
          }
          return "ok";
        },
      );
      return "error";
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
          imageFile.isEmpty
              ? Expanded(
                  child: TextInputField(
                      hintText: "Scrivi un messaggio...",
                      controller: _controller,
                      onChanged: (value) {}),
                )
              : Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.memory(
                            width: 200,
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              imageFile = Uint8List(0);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          IconButton(
              onPressed: () async {
                try {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    Uint8List file = await image.readAsBytes();
                    setState(() {
                      imageFile = file;
                    });
                  }
                } catch (e) {
                  print(e);
                }
              },
              icon: const Icon(
                Icons.image,
                size: 30,
                color: Colors.white,
              )),
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
