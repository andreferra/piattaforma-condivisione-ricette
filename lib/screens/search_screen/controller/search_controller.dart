import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condivisionericette/model/Filter.dart';
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

  void setTagSelected(int value) {
    state = state.copyWith(tagSelected: value);

    if (state.dropDownValue == SearchType.recipes) {
      _handlerTag();
    }
  }

  void setFilter(FiltroRicerca filter) {
    state = state.copyWith(filter: filter);
  }

  void setResults(List<DocumentSnapshot> results) {
    state = state.copyWith(results: results);
  }

  void setDifficolta(Difficolta difficolta) {
    state = state.copyWith(difficolta: difficolta);

    if (state.dropDownValue == SearchType.recipes) {
      _handlerDifficolta();
    }
  }

  ///funzione per filtrare le ricette in base ai tag
  void _handlerTag() {
    if (state.filter!.tag.isNotEmpty) {
      List<DocumentSnapshot> filtered = [];
      for (var recipe in state.recipes!) {
        recipe['tag'].forEach((element) {
          if (element == state.filter!.tag[state.tagSelected!]) {
            filtered.add(recipe);
          }
        });
      }
      state = state.copyWith(
          results: filtered.isNotEmpty ? filtered : state.recipes);
    } else {
      state = state.copyWith(results: state.recipes);
    }
  }

  ///funzione per filtrare le ricette in base alla difficoltà
  void _handlerDifficolta() {
    if (state.difficolta != Difficolta.tutte) {
      List<DocumentSnapshot> filtered = [];
      for (var recipe in state.recipes!) {
        if (recipe['difficolta'] ==
            state.difficolta.toString().split('.').last) {
          filtered.add(recipe);
          print(filtered.length);
        }
      }
      state = state.copyWith(
          results: filtered.isNotEmpty ? filtered : state.recipes);
    } else {
      state = state.copyWith(results: state.recipes);
    }
  }

  void setSearchType(SearchType value) {
    state = state.copyWith(dropDownValue: value);

    if (value == SearchType.all) {
      state = state.copyWith(results: [
        ...state.users!,
        ...state.recipes!,
      ]);
    } else if (value == SearchType.users) {
      state = state.copyWith(results: state.users);
    } else if (value == SearchType.recipes) {
      _handlerDifficolta();
    }
  }

  void resetSearch() {
    state = state.copyWith(
      users: [],
      isSearching: false,
      searchValue: null,
      recipes: [],
      results: [],
      isEmpty: true,
      filter: null,
      difficolta: Difficolta.tutte,
      dropDownValue: SearchType.all,
    );
  }

  Future<void> search() async {
    if (state.searchValue == null) return;
    if (state.users == null) state = state.copyWith(users: []);
    if (state.recipes == null) state = state.copyWith(recipes: []);
    if (state.results == null) state = state.copyWith(results: []);
    if (state.filter == null) {
      state = state.copyWith(filter: FiltroRicerca.empty());
    }

    List<DocumentSnapshot> users = [];
    List<DocumentSnapshot> recipes = [];
    try {
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
          if (recipe['tag'] != null && recipe['tag'].isNotEmpty) {
            for (var tag in recipe['tag']) {
              if (!state.filter!.tag.contains(tag)) {
                state.filter!.tag.add(tag);
              }
            }
          }
          if (recipe['ingredienti'] != null &&
              recipe['ingredienti'].isNotEmpty) {
            for (var ingrediente in recipe['ingredienti']) {
              if (!state.filter!.ingredienti.contains(ingrediente)) {
                state.filter!.ingredienti.add(ingrediente);
              }
            }
          }
          if (recipe['allergie'] != null && recipe['allergie'].isNotEmpty) {
            for (var allergene in recipe['allergie']) {
              if (!state.filter!.allergeni.contains(allergene)) {
                state.filter!.allergeni.add(allergene);
              }
            }
          }

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
    } catch (e) {
      print(e.toString());
    }
  }
}
