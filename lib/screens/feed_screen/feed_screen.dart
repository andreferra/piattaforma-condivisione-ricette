import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),

          ],
        )
      ),
    );
  }
}
