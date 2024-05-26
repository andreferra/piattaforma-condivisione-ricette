// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/screens/gaming%20/components/add_gaming_screen.dart';
import 'package:condivisionericette/screens/gaming%20/controller/gaming_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';

class GamingScreen extends ConsumerWidget {
  const GamingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameActive = ref.watch(gamingProvider).gameActive;
    print(gameActive);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      physics: const BouncingScrollPhysics(),
      child: gameActive
          ? Column(
              children: [
                const Header(),
                Text('Gaming Screen'),
              ],
            )
          : const AddGamingScreen(),
    );
  }
}
