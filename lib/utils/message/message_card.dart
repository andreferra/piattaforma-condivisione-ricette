// Flutter imports:
import 'package:flutter/material.dart';
// Project imports:
import 'package:model_repo/src/Message.dart';

class MessageCard extends StatelessWidget {
  final String mioId;
  final Message message;

  const MessageCard(this.message, this.mioId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.senderId == mioId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.senderId == mioId
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: message.type == MessageType.text
                ? const EdgeInsets.all(10)
                : null,
            decoration: BoxDecoration(
              color: message.senderId == mioId ? Colors.blue : Colors.grey,
              borderRadius: message.type == MessageType.text
                  ? BorderRadius.circular(30)
                  : BorderRadius.circular(0),
            ),
            child: message.type == MessageType.text
                ? Text(
                    message.message,
                    style: const TextStyle(color: Colors.white),
                  )
                : Image.network(
                    message.message,
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: message.senderId == mioId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 12,
              ),
              Text(
                message.timestamp.toDate().toString().substring(11, 16),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                message.isRead ? Icons.done_all : Icons.done,
                color: message.isRead ? Colors.blue : Colors.grey,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
