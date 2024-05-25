// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCard extends ConsumerWidget {
  final String nickname;
  final String userID;
  final String photoURL;
  final function;

  const UserCard(
      {super.key,
      required this.function,
      required this.nickname,
      required this.userID,
      required this.photoURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: function,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(photoURL),
            ),
            title: Text(nickname),
          ),
        ));
  }
}
