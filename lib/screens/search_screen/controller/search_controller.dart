import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'search_state.dart';

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>((ref) {
  return SearchController();
});

class SearchController extends StateNotifier<SearchState> {
  SearchController() : super(const SearchState());

  void setSearchValue(String value) {
    state = state.copyWith(searchValue: value);
  }

  void resetSearch() {
    state = state.copyWith(users: [], isSearching: false, searchValue: null);
  }

  Future<void> search() async {
    if (state.searchValue == null) return;
    if (state.users == null) state = state.copyWith(users: []);

    List<DocumentSnapshot> users = [];

    if (state.searchValue!.isNotEmpty) {
      users = await FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) => value.docs);

      for (var user in users) {
        if (user['nickname']
                .toString()
                .toLowerCase()
                .contains(state.searchValue!.toLowerCase()) ||
            user['name']
                .toString()
                .toLowerCase()
                .contains(state.searchValue!.toLowerCase())) {
          state = state.copyWith(
            users: [...state.users!, user],
          );
        }
      }

      if (state.users!.isNotEmpty) {
        state = state.copyWith(isSearching: true);
      }
    }
  }
}
