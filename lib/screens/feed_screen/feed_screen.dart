// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/controller/PageController.dart';
import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/controller/auth_repo_provider.dart';
import 'package:condivisionericette/screens/feed_screen/components/new_message.dart';
import 'package:condivisionericette/screens/feed_screen/components/new_notification.dart';
import 'package:condivisionericette/screens/feed_screen/components/recipe_list.dart';
import 'package:condivisionericette/screens/feed_screen/components/ricetta_casuale.dart';
import 'package:condivisionericette/screens/gaming/components/get_current_recipe.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:condivisionericette/widget/header.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final firebase = ref.watch(firebaseRepoProvider);

    return Scaffold(
      body: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: defaultPadding * 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(pageControllerProvider).setPage(2);
                    },
                    child: NewNotification(
                      userId: user.uid,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  InkWell(
                      onTap: () {
                        ref.read(pageControllerProvider).setPage(6);
                      },
                      child: NewMessage(
                        userID: user.uid,
                      )),
                  const SizedBox(width: defaultPadding),
                  if (user.gameActive!)
                    GetCurrentRecipe(
                      user: user,
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.5,
                    )
                ],
              ),
              const SizedBox(height: defaultPadding),
              const Divider(
                color: Colors.white54,
                thickness: 1,
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: RecipeList(user: user),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          RicettaCasuale(user: user),
                        ],
                      ))
                ],
              ),
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
