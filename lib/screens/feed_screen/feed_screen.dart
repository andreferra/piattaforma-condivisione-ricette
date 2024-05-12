import 'package:condivisionericette/controller/PageController.dart';
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

    return Scaffold(
      body: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: defaultPadding),
              Text(user.uid),
              Text(user.name!),
              Text(user.email!),
              Text(user.photoURL!),
              Text(user.bio!),
              Text(user.prefAlimentari!.toString()),
              Text(user.allergie!.toString()),
              Text(user.interessiCulinari!.toString()),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         ref.read(pageControllerProvider).setPage(5);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
