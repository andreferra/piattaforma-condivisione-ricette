// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:condivisionericette/model/Gaming.dart';

class UserLevelBadge extends StatelessWidget {
  final int level;
  final GameName name;

  UserLevelBadge({required this.level, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Livello $level',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: level / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(height: 10),
        Text(
          '${(level * 100).round()}%',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
