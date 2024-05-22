part of 'search_controller.dart';

class SearchState extends Equatable {
  final String? searchValue;
  final List<DocumentSnapshot>? users;
  final bool isSearching;

  const SearchState({
    this.searchValue,
    this.users,
    this.isSearching = false,
  });

  SearchState copyWith({
    String? searchValue,
    List<DocumentSnapshot>? users,
    bool? isSearching,
  }) {
    return SearchState(
      searchValue: searchValue ?? this.searchValue,
      users: users ?? this.users,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
        searchValue,
        users,
        isSearching,
      ];
}
