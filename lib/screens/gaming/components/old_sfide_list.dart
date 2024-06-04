// Flutter imports:
// Project imports:
import 'package:condivisionericette/widget/sfide/sfide_card.dart';
// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

class OldSfideList extends StatefulWidget {
  const OldSfideList({super.key});

  @override
  State<OldSfideList> createState() => _OldSfideListState();
}

class _OldSfideListState extends State<OldSfideList> {
  final FirebaseRepository firebase = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Sfidegame>>(
        future: firebase.getOldChallenge(),
        builder: (context, sfide) {
          if (sfide.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (sfide.hasError) {
            return const Center(
              child: Text('NESSUNA SFIDA VECCHIA'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: sfide.data!.length,
            itemBuilder: (context, index) {
              return SfideCard(
                sfida: sfide.data![index],
                old: true,
              );
            },
          );
        });
  }
}
