// Flutter imports:
// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/gaming%20/components/add_gaming_screen.dart';
import 'package:condivisionericette/screens/gaming%20/components/gaming_header.dart';
import 'package:condivisionericette/screens/gaming%20/controller/gaming_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamingScreen extends ConsumerWidget {
  const GamingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameActive = ref.watch(gamingProvider).gameActive;
    final user = ref.watch(authProvider).user;
    final FirebaseRepository firebase = FirebaseRepository();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      physics: const BouncingScrollPhysics(),
      child: gameActive
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Header(),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 200,
                  child: FutureBuilder(
                    future: firebase.getGamingData(user.uid),
                    builder: (context, gaming) {
                      if (gaming.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (gaming.hasError) {
                        return const Center(
                          child: Text('Errore nel caricamento dei dati'),
                        );
                      }
                      return GamingHeader(gaming: gaming.data!);
                    },
                  ),
                ),
              ],
            )
          : const AddGamingScreen(),
    );
  }
}
