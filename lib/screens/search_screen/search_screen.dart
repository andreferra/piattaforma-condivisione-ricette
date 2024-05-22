import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/screens/search_screen/components/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String searchValue = ref.watch(searchControllerProvider).searchValue!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            for (var user in snapshot.data!.docs) {
              if (user['nickname']
                  .toString()
                  .toLowerCase()
                  .contains(searchValue.toLowerCase())) {
                return UserCard(
                  nickname: user['nickname'],
                  userID: user['uid'],
                  photoURL: user['photoURL'],
                );
              }
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
