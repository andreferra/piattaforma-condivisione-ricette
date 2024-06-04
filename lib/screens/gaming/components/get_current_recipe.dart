// Flutter imports:

// Project imports:
import 'package:condivisionericette/screens/sfida_screen/sfida_screen.dart';
import 'package:condivisionericette/widget/sfide/sfide_card.dart';
// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:model_repo/model_repo.dart';

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
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'NESSUNA SFIDA IN CORSO',
                        style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
