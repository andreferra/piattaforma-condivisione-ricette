// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:condivisionericette/model/Filter.dart';

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

  void setAllergeniSelected(int value) {
    state = state.copyWith(allergeniSelected: value);

    if (state.dropDownValue == SearchType.recipes) {
      _handlerAllergeni();
    }
  }

  void setAlimentiSelected(int value) {
    state = state.copyWith(alimentiSelected: value);

    if (state.dropDownValue == SearchType.recipes) {
      _handlerAlimenti();
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

  ///funzione per filtrare le ricette in base agli allergeni
  void _handlerAllergeni() {
    if (state.filter!.allergeni.isNotEmpty) {
      List<DocumentSnapshot> filtered = [];
      for (var recipe in state.recipes!) {
        recipe['allergie'].forEach((element) {
          if (element == state.filter!.allergeni[state.allergeniSelected!] &&
              !filtered.contains(recipe)) {
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

  ///funzione per filtrare le ricette in base agli ingredienti
  void _handlerAlimenti() {
    if (state.filter!.ingredienti.isNotEmpty) {
      List<DocumentSnapshot> filtered = [];
      for (var recipe in state.recipes!) {
        recipe['allergie'].forEach((element) {
          if (element.toString().split(" ").first ==
                  state.filter!.ingredienti[state.alimentiSelected!] &&
              !filtered.contains(recipe)) {
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

  ///funzione per filtrare le ricette in base ai tag
  void _handlerTag() {
    if (state.filter!.tag.isNotEmpty) {
      List<DocumentSnapshot> filtered = [];
      for (var recipe in state.recipes!) {
        recipe['tag'].forEach((element) {
          if (element == state.filter!.tag[state.tagSelected!] &&
              !filtered.contains(recipe)) {
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
            if (!state.filter!.tag.contains('Tutte')) {
              state.filter!.tag.add('Tutte');
            }
            for (var tag in recipe['tag']) {
              if (!state.filter!.tag.contains(tag)) {
                state.filter!.tag.add(tag);
              }
            }
          }
          if (recipe['ingredienti'] != null &&
              recipe['ingredienti'].isNotEmpty) {
            if (!state.filter!.ingredienti.contains('Tutte')) {
              state.filter!.ingredienti.add('Tutte');
            }
            for (var ingrediente in recipe['ingredienti']) {
              if (!state.filter!.ingredienti.contains(ingrediente)) {
                state.filter!.ingredienti
                    .add(ingrediente.toString().split(" ").first);
              }
            }
          }
          if (recipe['allergie'] != null && recipe['allergie'].isNotEmpty) {
            if (!state.filter!.allergeni.contains('Tutte')) {
              state.filter!.allergeni.add('Tutte');
            }
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
