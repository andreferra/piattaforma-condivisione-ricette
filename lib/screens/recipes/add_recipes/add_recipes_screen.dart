import 'package:condivisionericette/screens/profile_screen/components/interessiAlimentari.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/GeneralInfo.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/components/header_recipes.dart';
import 'package:condivisionericette/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRecipesScreen extends ConsumerWidget {
  const AddRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding * 1.25,
            ),
            const HeaderRecipes(),
            const SizedBox(
              height: defaultPadding * 1.25,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Row(
                children:  [
                   Ingredienti(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
