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

  void setResults(List<DocumentSnapshot> results) {
    state = state.copyWith(results: results);
  }

  void setDropDownValue(SearchType value) {
    state = state.copyWith(dropDownValue: value);

    if (value == SearchType.all) {
      state = state.copyWith(results: [
        ...state.users!,
        ...state.recipes!,
      ]);
    } else if (value == SearchType.users) {
      state = state.copyWith(results: state.users);
    } else if (value == SearchType.recipes) {
      state = state.copyWith(results: state.recipes);
    }
  }

  void resetSearch() {
    state = state.copyWith(
        users: [],
        isSearching: false,
        searchValue: null,
        recipes: [],
        results: []);
  }

  Future<void> search() async {
    if (state.searchValue == null) return;
    if (state.users == null) state = state.copyWith(users: []);
    if (state.recipes == null) state = state.copyWith(recipes: []);
    if (state.results == null) state = state.copyWith(results: []);

    List<DocumentSnapshot> users = [];
    List<DocumentSnapshot> recipes = [];

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

      recipes = await FirebaseFirestore.instance
          .collection('recipes')
          .get()
          .then((value) => value.docs);

      for (var recipe in recipes) {
        if (recipe['nome_piatto']
                .toString()
                .toLowerCase()
                .contains(state.searchValue!.toLowerCase()) ||
            recipe['descrizione']
                .toString()
                .toLowerCase()
                .contains(state.searchValue!.toLowerCase())) {
          state = state.copyWith(
            recipes: [...state.recipes!, recipe],
          );
        }
      }

      if (state.users!.isNotEmpty || state.recipes!.isNotEmpty) {
        state = state.copyWith(isSearching: true, isEmpty: false, results: [
          ...state.users!,
          ...state.recipes!,
        ]);
      }

      if (state.users!.isEmpty && state.recipes!.isEmpty) {
        state = state.copyWith(isSearching: false, isEmpty: true);
      }
    }
  }
}
