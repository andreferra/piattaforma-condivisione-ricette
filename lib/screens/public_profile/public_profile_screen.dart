import 'dart:js_interop';

import 'package:condivisionericette/screens/public_profile/components/recipes_list.dart';
import 'package:condivisionericette/screens/public_profile/components/top_section.dart';
import 'package:condivisionericette/screens/public_profile/components/user_info.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';

class PublicProfile extends StatefulWidget {
  final String userID;

  const PublicProfile(this.userID, {super.key});

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  AuthUser user = AuthUser.empty;
  bool isLoad = false;

  void laodUserData() async {
    await _firebaseRepository.getUserFromDatabase(widget.userID).then((user) {
      if (mounted) {
        setState(() {
          isLoad = true;
          this.user = user;
        });
      }
    });
  }

  @override
  void initState() {
    laodUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ProfileInfoItem> items = [
      ProfileInfoItem("Recipes", user.posts!),
      ProfileInfoItem("Followers", user.follower!.length),
      ProfileInfoItem("Following", user.following!.length),
    ];

    return isLoad
        ? Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Expanded(
                    flex: 2, child: TopPortion(user.photoURL!, user.isLogged!)),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          user.nickname!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () {
                                //TODO follow user and active notification
                              },
                              heroTag: 'follow',
                              elevation: 0,
                              label: const Text("Follow"),
                              icon: const Icon(Icons.person_add_alt_1),
                            ),
                            const SizedBox(width: 16.0),
                            FloatingActionButton.extended(
                              onPressed: () {
                                //TODO message user
                              },
                              heroTag: 'mesage',
                              elevation: 0,
                              backgroundColor: Colors.red,
                              label: const Text("Message"),
                              icon: const Icon(Icons.message_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ProfileInfoRow(items)
                      ],
                    ),
                  ),
                ),
                RecipesList(user.uid),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class ProfileInfoItem {
  final String title;
  final int value;

  const ProfileInfoItem(this.title, this.value);
}
