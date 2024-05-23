part of 'search_controller.dart';

enum SearchType { all, users, recipes }

class SearchState extends Equatable {
  final String? searchValue;
  final List<DocumentSnapshot>? users;
  final List<DocumentSnapshot>? recipes;
  final List<DocumentSnapshot>? results;
  final bool isSearching;
  final bool isEmpty;
  final SearchType dropDownValue;

  const SearchState({
    this.searchValue,
    this.users,
    this.recipes,
    this.isSearching = false,
    this.isEmpty = true,
    this.results,
    this.dropDownValue = SearchType.all,
  });

  SearchState copyWith({
    String? searchValue,
    List<DocumentSnapshot>? users,
    List<DocumentSnapshot>? recipes,
    List<DocumentSnapshot>? results,
    bool? isSearching,
    bool? isEmpty,
    SearchType? dropDownValue,
  }) {
    return SearchState(
      searchValue: searchValue ?? this.searchValue,
      users: users ?? this.users,
      isSearching: isSearching ?? this.isSearching,
      recipes: recipes ?? this.recipes,
      isEmpty: isEmpty ?? this.isEmpty,
      results: results ?? this.results,
      dropDownValue: dropDownValue ?? this.dropDownValue,
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
      ];
}
