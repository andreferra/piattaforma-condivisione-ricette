part of 'search_controller.dart';

class SearchState extends Equatable {
  final String? searchValue;

  const SearchState({
    this.searchValue,
  });

  SearchState copyWith({
    String? searchValue,
    TextEditingController? searchController,
  }) {
    return SearchState(
      searchValue: searchValue ?? this.searchValue,
    );
  }

  @override
  List<Object?> get props => [
        searchValue,
      ];
}
