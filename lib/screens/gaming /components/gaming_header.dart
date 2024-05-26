// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:condivisionericette/model/Gaming.dart';
import 'package:condivisionericette/screens/gaming%20/components/user_level_badge.dart';

class GamingHeader extends StatelessWidget {
  final Gaming gaming;
  const GamingHeader({required this.gaming, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserLevelBadge(level: gaming.punti, name: gaming.gameName),
        ],
      ),
    );
  }
}
