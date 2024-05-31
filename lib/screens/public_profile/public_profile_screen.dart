// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:condivisionericette/model/Message.dart';
import 'package:condivisionericette/model/Notification.dart';
import 'package:condivisionericette/screens/message_screen/singleChat/single_chat.dart';
import 'package:condivisionericette/screens/public_profile/components/recipes_list.dart';
import 'package:condivisionericette/screens/public_profile/components/top_section.dart';
import 'package:condivisionericette/screens/public_profile/components/user_info.dart';
import 'package:condivisionericette/utils/constant.dart';
import '../../widget/share/share_screen.dart';

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
  NotificationModel notification = NotificationModel.empty();
  bool isLoad = false;
  bool loSeguo = false;
  bool notifiche = false;
  String nomeGioco = "";

  void laodUserData() async {
    try {
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
          if (user.gameActive!) {
            _handlerNameGioco(user.gaming!.gameName);
          }
        }
      });
    } on Exception catch (e) {
      print("loadUserData(): ${e.toString()}");
    }
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
    } on Exception catch (e) {
      print("unfollowUser(): ${e.toString()}");
    }
  }

  Future<void> _followUser() async {
    try {
      notification = NotificationModel(
          notificationId: const Uuid().v4(),
          title: 'Nuovo Follower',
          body: 'Hai un nuovo follower 🥳',
          userSender: widget.mioId,
          userReceiver: user.uid,
          type: NotificationType.newFollower,
          date: DateTime.now().toString(),
          extraData: "");
      await _firebaseRepository
          .followUser(
              widget.mioId, user.uid, notification.toMap(), user.gaming!)
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
    } on Exception catch (e) {
      print("followUser(): $e");
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

  Future<void> _checkChat(String id, String mioId) async {
    await _firebaseRepository.checkChat(id, mioId).then((value) {});
  }

  void _handlerNameGioco(GameName nome) {
    String nomeSplittato = nome.toString().split('.').last;
    String nomeCompelto = nomeSplittato.substring(0, 1).toUpperCase() +
        nomeSplittato.substring(1).toLowerCase();

    setState(() {
      nomeGioco = nomeCompelto;
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            const SizedBox(width: defaultPadding),
                            if (user.gameActive!)
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.blue, Colors.green],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding * 2,
                                    vertical: defaultPadding * 0.5),
                                child: Text(
                                  nomeGioco,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (user.uid != widget.mioId)
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
                                onPressed: () async {
                                  await _checkChat(user.uid, widget.mioId);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SingleChatScreen(
                                          user.uid, widget.mioId)));
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
                              const SizedBox(width: 16.0),
                              FloatingActionButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) => ShareScreen(
                                                widget.mioId,
                                                widget.userID,
                                                MessageType.user,
                                              )));
                                },
                                backgroundColor: Colors.green,
                                child: const Icon(Icons.share),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ProfileInfoRow(items),
                        )
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
