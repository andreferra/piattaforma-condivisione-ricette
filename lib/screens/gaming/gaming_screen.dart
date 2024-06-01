// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth_repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/gaming/components/add_gaming_screen.dart';
import 'package:condivisionericette/screens/gaming/components/classifica.dart';
import 'package:condivisionericette/screens/gaming/components/gaming_header.dart';
import 'package:condivisionericette/screens/gaming/components/get_current_recipe.dart';
import 'package:condivisionericette/screens/gaming/components/next_sfide_list.dart';
import 'package:condivisionericette/screens/gaming/components/old_sfide_list.dart';
import 'package:condivisionericette/screens/gaming/controller/gaming_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.12,
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
                const SizedBox(height: 20),
                const GetCurrentRecipe(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClassificaUtenti(mioId: user.uid),
                    ),
                    const Expanded(
                      child: NextSfideList(),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.white60,
                  thickness: 2,
                ),
                const Center(
                  child: Text(
                    'Sfide terminate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const OldSfideList(),
              ],
            )
          : const AddGamingScreen(),
    );
  }
}
