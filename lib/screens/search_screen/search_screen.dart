import 'package:condivisionericette/screens/search_screen/components/user_card.dart';
import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(searchControllerProvider.notifier);

    final searchResult = ref.watch(searchControllerProvider).users;
    final isSearching = ref.watch(searchControllerProvider).isSearching;
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
            // TODO: add search with tag and

            if (ref.watch(searchControllerProvider).users != null)
              SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView.builder(
                    itemCount:
                        ref.watch(searchControllerProvider).users!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: UserCard(
                          nickname: searchResult![index]['nickname'],
                          photoURL: searchResult[index]['photoURL'],
                          userID: searchResult[index].id,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ));
  }
}
