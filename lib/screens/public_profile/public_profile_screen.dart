import 'dart:js_interop';

import 'package:condivisionericette/screens/public_profile/components/recipes_list.dart';
import 'package:condivisionericette/screens/public_profile/components/top_section.dart';
import 'package:condivisionericette/screens/public_profile/components/user_info.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PublicProfile extends StatefulWidget {
  final String userID;
  final String mioId;

  const PublicProfile(this.userID, this.mioId, {super.key});

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  AuthUser user = AuthUser.empty;
  bool isLoad = false;
  bool loSeguo = false;
  bool notifiche = false;

  void laodUserData() async {
    await _firebaseRepository.getUserFromDatabase(widget.userID).then((user) {
      if (mounted) {
        setState(() {
          isLoad = true;
          this.user = user;
          user.follower!.contains(widget.mioId)
              ? loSeguo = true
              : loSeguo = false;
          user.listaNotifiche!.contains(widget.mioId)
              ? notifiche = true
              : notifiche = false;
        });
      }
    });
  }

  Future<void> _unfollowUser() async {
    try {
      await _firebaseRepository
          .unfollowUser(widget.mioId, user.uid)
          .then((value) {
        switch (value) {
          case 'ok':
            if (loSeguo) {
              _togliNotifiche();
            }
            setState(() {
              loSeguo = false;
              user.follower!.remove(widget.mioId);
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("utente smesso di seguire")));
            break;
          default:
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Errore")));
            break;
        }
      });
    } on UpdateProfileFailure catch (e) {
      print(e);
    }
  }

  Future<void> _followUser() async {
    try {
      await _firebaseRepository
          .followUser(widget.mioId, user.uid)
          .then((value) {
        switch (value) {
          case 'ok':
            setState(() {
              loSeguo = true;
              user.follower!.add(widget.mioId);
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("utente seguito con successo")));
            break;
          default:
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Errore")));
            break;
        }
      });
    } on UpdateProfileFailure catch (e) {
      print(e);
    }
  }

  Future<void> _notificaUser() async {
    try {
      await _firebaseRepository
          .addNotification(widget.mioId, user.uid)
          .then((value) {
        switch (value) {
          case 'ok':
            setState(() {
              notifiche = true;
              user.listaNotifiche!.add(widget.mioId);
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifiche attivate")));
            break;
          default:
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Errore")));
            break;
        }
      });
    } on UpdateProfileFailure catch (e) {
      print(e);
    }
  }

  Future<void> _togliNotifiche() async {
    try {
      await _firebaseRepository
          .deleteNotification(widget.mioId, user.uid)
          .then((value) {
        switch (value) {
          case 'ok':
            setState(() {
              notifiche = false;
              user.listaNotifiche!.remove(widget.mioId);
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifiche disattivate")));
            break;
          default:
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Errore")));
            break;
        }
      });
    } on UpdateProfileFailure catch (e) {
      print(e);
    }
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
                              onPressed: () async {
                                loSeguo
                                    ? await _unfollowUser()
                                    : await _followUser();
                              },
                              heroTag: !loSeguo ? 'follow' : "unfollow",
                              elevation: 0,
                              label: !loSeguo
                                  ? const Text("Follow")
                                  : const Text("Unfollow"),
                              icon: !loSeguo
                                  ? const Icon(Icons.person_add_alt_1)
                                  : const Icon(Icons.person_remove_alt_1),
                            ),
                            const SizedBox(width: 16.0),
                            FloatingActionButton.extended(
                              onPressed: () {
                                //TODO: implement message
                              },
                              heroTag: 'mesage',
                              elevation: 0,
                              backgroundColor: Colors.red,
                              label: const Text("Message"),
                              icon: const Icon(Icons.message_rounded),
                            ),
                            const SizedBox(width: 16.0),
                            if (loSeguo)
                              FloatingActionButton.extended(
                                onPressed: () {
                                  !notifiche
                                      ? _notificaUser()
                                      : _togliNotifiche();
                                },
                                heroTag: "Notifiche",
                                elevation: 0,
                                backgroundColor: Colors.blue,
                                label: notifiche
                                    ? const Text("Notifiche attive")
                                    : const Text("Notifiche disattive"),
                                icon: notifiche
                                    ? const Icon(Icons.notifications_active)
                                    : const Icon(Icons.notifications_off),
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
