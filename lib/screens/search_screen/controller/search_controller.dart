import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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

  void setSearchController(TextEditingController controller) {
    state = state.copyWith(searchController: controller);
  }
}
