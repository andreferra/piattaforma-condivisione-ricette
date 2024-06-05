// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/gaming/components/next_sfide_list_components.dart';

class NextSfideList extends StatefulWidget {
  const NextSfideList({super.key});

  @override
  State<NextSfideList> createState() => _NextSfideListState();
}

class _NextSfideListState extends State<NextSfideList> {
  final FirebaseRepository firebase = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Sfidegame>>(
        future: firebase.getNextChallenge(),
        builder: (context, sfide) {
          if (sfide.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (sfide.hasError) {
            return const Center(
              child: Text('NESSUNA SFIDA PREVISTA'),
            );
          }

          return Column(
            children: [
              Text(
                'Prossime sfide',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: sfide.data!.length,
                itemBuilder: (context, index) {
                  return NextSfideListComponents(sfidegame: sfide.data![index]);
                },
              ),
            ],
          );
        });
  }
}
