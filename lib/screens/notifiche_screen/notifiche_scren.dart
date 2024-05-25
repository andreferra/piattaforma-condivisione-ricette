import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:flutter/material.dart';

class NotificheScreen extends StatelessWidget {
  const NotificheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.all(defaultPadding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Header(),
          Text('Notifiche'),
        ],
      ),
    ));
  }
}
