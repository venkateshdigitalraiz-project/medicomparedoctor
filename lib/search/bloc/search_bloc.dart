import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc()
      : super(const SearchState(
          recentSearches: [
            'Rajesh',
            'Fathima',
            'kanna',
            'Ganesh',
            'Lakshmi',
          ],
        )) {
    on<SearchOpened>(_onSearchOpened);
    on<SearchClosed>(_onSearchClosed);
    on<SearchQueryChanged>(_onQueryChanged);
    on<RecentSearchRemoved>(_onRecentSearchRemoved);
    on<SearchSubmitted>(_onSearchSubmitted);
  }

  void _onSearchOpened(SearchOpened event, Emitter<SearchState> emit) {
    // Tapping search shows ONLY the search screen (recent list), query reset.
    emit(state.copyWith(isSearchOpen: true, query: ''));
  }

  void _onSearchClosed(SearchClosed event, Emitter<SearchState> emit) {
    emit(state.copyWith(isSearchOpen: false, query: ''));
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    // visibleResults getter in SearchState re-filters automatically.
    emit(state.copyWith(query: event.query));
  }

  void _onRecentSearchRemoved(
      RecentSearchRemoved event, Emitter<SearchState> emit) {
    final updated = List<String>.from(state.recentSearches)
      ..remove(event.term);
    emit(state.copyWith(recentSearches: updated));
  }

  void _onSearchSubmitted(SearchSubmitted event, Emitter<SearchState> emit) {
    final term = event.term.trim();
    if (term.isEmpty) return;
    final updated = List<String>.from(state.recentSearches)
      ..remove(term)
      ..insert(0, term);
    emit(state.copyWith(recentSearches: updated, query: ''));
  }
}
