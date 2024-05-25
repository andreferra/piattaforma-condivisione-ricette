import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/model/Message.dart';
import 'package:condivisionericette/model/Notification.dart';
import 'package:condivisionericette/screens/search_screen/components/user_card.dart';
import 'package:condivisionericette/widget/loading_errors.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ShareScreen extends StatefulWidget {
  final String mioId;
  final String shareUid;
  final MessageType messageType;
  const ShareScreen(this.mioId, this.shareUid, this.messageType, {super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  List<DocumentSnapshot> result = [];
  List<DocumentSnapshot> filteredResult = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  void _loadUser() async {
    List<DocumentSnapshot> user = [];
    try {
      FirebaseFirestore.instance
          .collection("users")
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          if (element.id != widget.mioId) {
            user.add(element);
          }
        }
      });
      setState(() {
        result = user;
        filteredResult = user;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onSearchChanged() {
    setState(() {
      filteredResult = result
          .where((element) =>
              element['nickname'].toString().contains(_searchController.text))
          .toList();
    });
  }

  @override
  void initState() {
    _loadUser();

    _searchController.addListener(_onSearchChanged);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    super.initState();
  }

  Future<String> _sendMessage(DocumentSnapshot document) async {
    try {
      Message message = Message(
        senderId: widget.mioId,
        receiverId: document.id,
        message: widget.shareUid,
        timestamp: Timestamp.now(),
        isRead: false,
        id: const Uuid().v4(),
        type: widget.messageType,
      );
      NotificationModel notificationModel = NotificationModel(
        notificationId: const Uuid().v4(),
        title: "Nuovo messaggio",
        body: "Hai ricevuto un nuovo messaggio da ${document['nickname']} 👀",
        date: DateTime.now().toString(),
        userSender: widget.mioId,
        userReceiver: document.id,
        type: NotificationType.newMessage,
        extraData: "ricetta o utente condiviso",
        read: false,
      );
      await _firebaseRepository.sendMessage(
        message.toJson(),
        document.id,
        widget.mioId,
        widget.messageType.toString().split('.').last,
        Uint8List(0),
        notificationModel.toMap(),
      );
      return "ok";
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Condividi'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    focusNode: FocusNode(),
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cerca',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredResult.length,
                    itemBuilder: (context, index) {
                      return UserCard(
                        nickname: filteredResult[index]['nickname'],
                        userID: filteredResult[index].id,
                        photoURL: filteredResult[index]['photoURL'],
                        function: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Condividi"),
                              content: widget.messageType == MessageType.recipe
                                  ? Text(
                                      "Condividi la ricetta con ${filteredResult[index]['nickname'].toString().toUpperCase()} in chat?")
                                  : Text(
                                      "Condividi il profilo con ${filteredResult[index]['nickname'].toString().toUpperCase()} in chat?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Annulla"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _sendMessage(filteredResult[index])
                                        .then(
                                      (value) {
                                        if (value == "ok") {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          ErrorDialog.show(
                                            context,
                                            widget.messageType ==
                                                    MessageType.recipe
                                                ? "Ricetta condivisa con successo"
                                                : "Profilo condiviso con successo",
                                          );
                                        } else {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          ErrorDialog.show(
                                            context,
                                            widget.messageType ==
                                                    MessageType.recipe
                                                ? "Errore durante la condivisione"
                                                : "Errore durante la condivisione del profilo",
                                          );
                                        }
                                      },
                                    );
                                  },
                                  child: const Text("Condividi"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
