// Flutter imports:
import 'package:flutter/material.dart';

class HeaderSfida extends StatefulWidget {
  const HeaderSfida({super.key});

  @override
  State<HeaderSfida> createState() => _HeaderSfidaState();
}

class _HeaderSfidaState extends State<HeaderSfida> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'SFIDA IN CORSO',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Scopri la ricetta da preparare e unisiciti alla sfida!',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
