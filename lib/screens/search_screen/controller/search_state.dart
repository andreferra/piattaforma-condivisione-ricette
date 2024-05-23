part of 'search_controller.dart';

enum SearchType { all, users, recipes }

enum Difficolta { facile, media, difficile, tutte }

class SearchState extends Equatable {
  final String? searchValue;
  final List<DocumentSnapshot>? users;
  final List<DocumentSnapshot>? recipes;
  final List<DocumentSnapshot>? results;
  final bool isSearching;
  final bool isEmpty;
  final int? tagSelected;
  final SearchType dropDownValue;
  final FiltroRicerca? filter;
  final Difficolta? difficolta;

  const SearchState({
    this.searchValue,
    this.users,
    this.recipes,
    this.tagSelected,
    this.isSearching = false,
    this.isEmpty = true,
    this.results,
    this.dropDownValue = SearchType.all,
    this.difficolta = Difficolta.tutte,
    this.filter,
  });

  SearchState copyWith({
    String? searchValue,
    List<DocumentSnapshot>? users,
    List<DocumentSnapshot>? recipes,
    List<DocumentSnapshot>? results,
    bool? isSearching,
    bool? isEmpty,
    int? tagSelected,
    SearchType? dropDownValue,
    FiltroRicerca? filter,
    Difficolta? difficolta,
  }) {
    return SearchState(
      searchValue: searchValue ?? this.searchValue,
      users: users ?? this.users,
      isSearching: isSearching ?? this.isSearching,
      recipes: recipes ?? this.recipes,
      isEmpty: isEmpty ?? this.isEmpty,
      results: results ?? this.results,
      dropDownValue: dropDownValue ?? this.dropDownValue,
      filter: filter ?? this.filter,
      difficolta: difficolta ?? this.difficolta,
      tagSelected: tagSelected ?? this.tagSelected,
    );
  }

  @override
  List<Object?> get props => [
        searchValue,
        users,
        isSearching,
        recipes,
        isEmpty,
        results,
        dropDownValue,
        tagSelected,
        filter,
        difficolta,
      ];
}
