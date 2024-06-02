// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:model_repo/model_repo.dart';

// Project imports:
import 'package:condivisionericette/screens/sfida_screen/sfida_screen.dart';
import 'package:condivisionericette/widget/sfide/sfide_card.dart';

class GetCurrentRecipe extends StatelessWidget {
  final AuthUser user;
  const GetCurrentRecipe({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    FirebaseRepository firebase = FirebaseRepository();
    return FutureBuilder<Sfidegame>(
        future: firebase.getCurrentSfida(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Errore nel caricamento dei dati'),
            );
          }
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SfidaScreen(
                    sfide: snapshot.data!,
                    user: user,
                  ),
                ),
              );
            },
            child: SfideCard(sfida: snapshot.data!),
          );
        });
  }
}
