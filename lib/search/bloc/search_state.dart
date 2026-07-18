part of 'search_bloc.dart';

class SearchState extends Equatable {
  /// Whether the full-screen search UI is open.
  final bool isSearchOpen;

  /// The raw text currently typed in the search field.
  final String query;

  /// The full list of recent searches (source of truth).
  final List<String> recentSearches;

  /// The list actually shown to the user: all recent searches when the
  /// query is empty, otherwise only the ones that contain the typed letters.
  List<String> get visibleResults {
    if (query.trim().isEmpty) return recentSearches;
    final lower = query.toLowerCase();
    return recentSearches
        .where((term) => term.toLowerCase().contains(lower))
        .toList();
  }

  const SearchState({
    this.isSearchOpen = false,
    this.query = '',
    this.recentSearches = const [],
  });

  SearchState copyWith({
    bool? isSearchOpen,
    String? query,
    List<String>? recentSearches,
  }) {
    return SearchState(
      isSearchOpen: isSearchOpen ?? this.isSearchOpen,
      query: query ?? this.query,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }

  @override
  List<Object?> get props => [isSearchOpen, query, recentSearches];
}
