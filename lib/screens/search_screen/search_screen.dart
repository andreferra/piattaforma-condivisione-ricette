import 'package:condivisionericette/widget/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(searchControllerProvider.notifier);
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
                    hintText: 'Search',
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
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      await searchController.search();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Search result'),
          ],
        ));
  }
}
