// Flutter imports:
// Project imports:
import 'package:condivisionericette/model/Gaming.dart';
import 'package:condivisionericette/screens/gaming%20/components/sfide_badge.dart';
import 'package:condivisionericette/screens/gaming%20/components/user_level_badge.dart';
import 'package:flutter/material.dart';

class GamingHeader extends StatelessWidget {
  final Gaming gaming;
  const GamingHeader({required this.gaming, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserLevelBadge(
            point: gaming.punti,
            name: gaming.gameName,
          ),
          SfideBadge(
            sfidePartecipate: gaming.sfidePartecipate,
            sfideVinte: gaming.sfideVinte,
          ),
        ],
      ),
    );
  }
}
