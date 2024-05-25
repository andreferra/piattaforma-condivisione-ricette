import 'package:condivisionericette/controller/auth_controller/auth_controller.dart';
import 'package:condivisionericette/screens/public_profile/public_profile_screen.dart';
import 'package:condivisionericette/screens/recipes/add_recipes/controller/recipes_controller.dart';
import 'package:condivisionericette/screens/recipes/view_screen/view_recipe_screen.dart';
import 'package:condivisionericette/screens/search_screen/components/user_card.dart';
import 'package:condivisionericette/widget/dropDown/DropDownFilter.dart';
import 'package:condivisionericette/widget/dropDown/DropDownMenu.dart';
import 'package:condivisionericette/widget/recipe_card.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final searchController = ref.watch(searchControllerProvider.notifier);
    final serachState = ref.watch(searchControllerProvider);

    final result = ref.watch(searchControllerProvider).results;
    final userResult = ref.watch(searchControllerProvider).users;
    final recipeResult = ref.watch(searchControllerProvider).recipes;

    final isSearching = ref.watch(searchControllerProvider).isSearching;
    final isEmpty = ref.watch(searchControllerProvider).isEmpty;

    final selectedType = ref.watch(searchControllerProvider).dropDownValue;
    final selectedDifficolta = ref.watch(searchControllerProvider).difficolta;

    final filter = ref.watch(searchControllerProvider).filter;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextInputField(
                    hintText: 'Search user or recipe name',
                    onChanged: (value) {
                      searchController.setSearchValue(value);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(10))),
                    icon: isSearching
                        ? const Icon(Icons.remove_circle_outline)
                        : const Icon(Icons.search),
                    onPressed: () async {
                      isSearching
                          ? searchController.resetSearch()
                          : await searchController.search();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (result != null && result.isNotEmpty)
              Row(
                children: [
                  if (userResult != null &&
                      userResult.isNotEmpty &&
                      recipeResult != null &&
                      recipeResult.isNotEmpty)
                    Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: DropDown(
                          underline: Container(),
                          itemList: const ['All', 'Users', 'Recipes'],
                          selectOption: selectedType,
                          onChange: (value) {
                            if (value == 'All') {
                              searchController.setSearchType(SearchType.all);
                            } else if (value == 'Users') {
                              searchController.setSearchType(SearchType.users);
                            } else if (value == 'Recipes') {
                              searchController
                                  .setSearchType(SearchType.recipes);
                            }
                          },
                        )),
                  if (selectedType == SearchType.recipes)
                    Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: DropDown(
                          underline: Container(),
                          itemList: const [
                            'Facile',
                            'Media',
                            'Difficile',
                            'Tutte'
                          ],
                          selectOption: selectedDifficolta,
                          onChange: (value) {
                            if (value == 'Facile') {
                              searchController.setDifficolta(Difficolta.facile);
                            } else if (value == 'Media') {
                              searchController.setDifficolta(Difficolta.media);
                            } else if (value == 'Difficile') {
                              searchController
                                  .setDifficolta(Difficolta.difficile);
                            } else if (value == 'Tutte') {
                              searchController.setDifficolta(Difficolta.tutte);
                            }
                          },
                        )),
                  if (selectedType == SearchType.recipes &&
                      filter!.tag.isNotEmpty)
                    Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: DropDownFilter(
                          underline: Container(),
                          itemList: filter.tag,
                          selectOption: serachState.tagSelected ?? 0,
                          onChange: (value) {
                            searchController.setTagSelected(
                                filter.tag.indexOf(value.toString()));
                          },
                        )),
                  if (selectedType == SearchType.recipes &&
                      filter!.ingredienti.isNotEmpty)
                    Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: DropDownFilter(
                          underline: Container(),
                          itemList: filter.ingredienti,
                          selectOption: serachState.alimentiSelected ?? 0,
                          onChange: (value) {
                            searchController.setAlimentiSelected(
                                filter.ingredienti.indexOf(value.toString()));
                          },
                        )),
                  if (selectedType == SearchType.recipes &&
                      filter!.allergeni.isNotEmpty)
                    Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: DropDownFilter(
                          underline: Container(),
                          itemList: filter.allergeni,
                          selectOption: serachState.allergeniSelected ?? 0,
                          onChange: (value) {
                            searchController.setAllergeniSelected(
                                filter.allergeni.indexOf(value.toString()));
                          },
                        )),
                ],
              ),
            SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      if (result != null && result.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            shrinkWrap: true,
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              if (result[index].data() == null) {
                                return const SizedBox();
                              }
                              Map<String, dynamic> data =
                                  result[index].data() as Map<String, dynamic>;

                              return InkWell(
                                onTap: () {
                                  if (data.containsKey('email')) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PublicProfile(
                                          result[index].id, user.uid);
                                    }));
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ViewRecipeScreen(
                                        recipesState: RecipesState.fromSnapshot(
                                            result[index]),
                                        isMine: result[index].id == user.uid,
                                        mioId: user.uid,
                                      );
                                    }));
                                  }
                                },
                                child: data.containsKey('email')
                                    ? Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: UserCard(
                                          nickname: result[index]['nickname'],
                                          photoURL: result[index]['photoURL'],
                                          userID: result[index].id,
                                          function: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return PublicProfile(
                                                  result[index].id, user.uid);
                                            }));
                                          },
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: RecipeListItem(
                                          imageUrl: result[index]
                                              ['cover_image'],
                                          title: result[index]['nome_piatto'],
                                          description: result[index]
                                                  ['descrizione']
                                              .toString(),
                                          numeroCommenti: result[index]
                                                  ['numero_commenti']
                                              .toString(),
                                          numeroLike: result[index]
                                                  ['numero_like']
                                              .toString(),
                                          numeroCondivisioni: result[index]
                                                  ['numero_condivisioni']
                                              .toString(),
                                          visualizzazioni: result[index]
                                                  ['numero_visualizzazioni']
                                              .toString(),
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                )),
            if (isEmpty) const Center(child: Text('No results found')),
          ],
        ));
  }
}
