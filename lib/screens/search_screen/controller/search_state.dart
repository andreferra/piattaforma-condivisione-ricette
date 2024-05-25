part of 'search_controller.dart';

enum SearchType { all, users, recipes }

enum Difficolta { facile, media, difficile, tutte }

enum NumeroStelle { uno, due, tre, quattro, cinque, tutte }

class SearchState extends Equatable {
  final String? searchValue;
  final List<DocumentSnapshot>? users;
  final List<DocumentSnapshot>? recipes;
  final List<DocumentSnapshot>? results;
  final bool isSearching;
  final bool isEmpty;
  final int? tagSelected;
  final int? alimentiSelected;
  final int? allergeniSelected;
  final int? numeroStelleSelected;
  final SearchType dropDownValue;
  final FiltroRicerca? filter;
  final NumeroStelle? numeroStelle;
  final Difficolta? difficolta;

  const SearchState({
    this.searchValue,
    this.users,
    this.recipes,
    this.tagSelected,
    this.isSearching = false,
    this.isEmpty = true,
    this.results,
    this.allergeniSelected,
    this.dropDownValue = SearchType.all,
    this.difficolta = Difficolta.tutte,
    this.filter,
    this.numeroStelle = NumeroStelle.tutte,
    this.numeroStelleSelected,
    this.alimentiSelected,
  });

  SearchState copyWith({
    String? searchValue,
    List<DocumentSnapshot>? users,
    List<DocumentSnapshot>? recipes,
    List<DocumentSnapshot>? results,
    bool? isSearching,
    bool? isEmpty,
    int? tagSelected,
    int? allergeniSelected,
    int? numeroStelleSelected,
    NumeroStelle? numeroStelle,
    SearchType? dropDownValue,
    FiltroRicerca? filter,
    Difficolta? difficolta,
    int? alimentiSelected,
  }) {
    return SearchState(
      searchValue: searchValue ?? this.searchValue,
      users: users ?? this.users,
      isSearching: isSearching ?? this.isSearching,
      recipes: recipes ?? this.recipes,
      isEmpty: isEmpty ?? this.isEmpty,
      results: results ?? this.results,
      numeroStelleSelected: numeroStelleSelected ?? this.numeroStelleSelected,
      numeroStelle: numeroStelle ?? this.numeroStelle,
      dropDownValue: dropDownValue ?? this.dropDownValue,
      filter: filter ?? this.filter,
      allergeniSelected: allergeniSelected ?? this.allergeniSelected,
      difficolta: difficolta ?? this.difficolta,
      tagSelected: tagSelected ?? this.tagSelected,
      alimentiSelected: alimentiSelected ?? this.alimentiSelected,
    );
  }

  @override
  List<Object?> get props => [
        searchValue,
        users,
        numeroStelleSelected,
        numeroStelle,
        isSearching,
        recipes,
        isEmpty,
        results,
        dropDownValue,
        tagSelected,
        allergeniSelected,
        alimentiSelected,
        filter,
        difficolta,
      ];
}
