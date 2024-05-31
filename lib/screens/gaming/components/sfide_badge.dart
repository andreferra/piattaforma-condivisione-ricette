// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:condivisionericette/utils/constant.dart';

class SfideBadge extends StatefulWidget {
  final int sfideVinte;
  final int sfidePartecipate;
  const SfideBadge(
      {super.key, required this.sfideVinte, required this.sfidePartecipate});

  @override
  State<SfideBadge> createState() => _SfideBadgeState();
}

class _SfideBadgeState extends State<SfideBadge> {
  int get sfideVinte => widget.sfideVinte;
  int get sfidePartecipate => widget.sfidePartecipate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sfide giocate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Text(
                sfidePartecipate.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sfide vinte',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Text(
                sfideVinte.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
