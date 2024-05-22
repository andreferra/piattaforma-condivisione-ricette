import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/public_profile/public_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCard extends ConsumerWidget {
  final String nickname;
  final String userID;
  final String photoURL;

  const UserCard(
      {super.key,
      required this.nickname,
      required this.userID,
      required this.photoURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  PublicProfile(userID, user.uid))); // Add the user ID
        },
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
