import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  recipe,
  user,
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool isRead;
  final MessageType type;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isRead,
    this.type = MessageType.text,
  });

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      throw Exception('Document does not exist');
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (!data.containsKey('senderId')) {
      throw Exception('Field "senderId" does not exist in the document');
    }

    return Message(
      id: snapshot.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      message: data['message'],
      timestamp: data['timestamp'],
      isRead: data['isRead'],
      type: MessageType.values[data['type']],
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      timestamp: json['timestamp'],
      isRead: json['isRead'],
      type: MessageType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
      'type': type.index,
    };
  }
}
