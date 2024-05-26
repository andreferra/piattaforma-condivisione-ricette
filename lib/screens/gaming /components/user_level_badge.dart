// Project imports:
import 'package:condivisionericette/model/Gaming.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserLevelBadge extends StatefulWidget {
  final int point;
  final GameName name;
  const UserLevelBadge({super.key, required this.point, required this.name});

  @override
  State<UserLevelBadge> createState() => _UserLevelBadgeState();
}

class _UserLevelBadgeState extends State<UserLevelBadge> {
  GameName get name => widget.name;
  int get point => widget.point;
  List<int> levelPoint = [0, 0];

  void _handlerLevelPoint() {
    switch (name) {
      case GameName.ReginaDellaPasta:
        levelPoint = [0, 500];
        break;
      case GameName.MaestroDiDolci:
        levelPoint = [500, 1000];
        break;
      case GameName.ReDellaPizza:
        levelPoint = [1000, 2000];
        break;
      case GameName.GrillMaster5000:
        levelPoint = [2000, 4000];
        break;
      case GameName.SushiChef:
        levelPoint = [4000, 10000];
        break;
    }
  }

  @override
  void initState() {
    _handlerLevelPoint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffAEC5EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            name.toString().split('.').last,
            style: const TextStyle(
                color: Color(0xff3A405A),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            animation: true,
            animationDuration: 1500,
            barRadius: const Radius.circular(20),
            center: Text(
              "$point/${levelPoint[1]}",
              style: const TextStyle(
                  color: Color(0xff3A405A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            lineHeight: 20,
            percent: (point - levelPoint[0]) / (levelPoint[1] - levelPoint[0]),
            progressColor: const Color(0xff88BB92),
          ),
        ],
      ),
    );
  }
}
