part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps the search bar on the home screen.
/// Opens the full-screen search UI showing recent searches (nothing else).
class SearchOpened extends SearchEvent {
  const SearchOpened();
}

/// Fired when the user taps the back arrow on the search screen.
class SearchClosed extends SearchEvent {
  const SearchClosed();
}

/// Fired on every keystroke in the search field.
/// Filters the recent-search list by the typed letters.
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Fired when the user taps the "X" next to a recent search item.
class RecentSearchRemoved extends SearchEvent {
  final String term;
  const RecentSearchRemoved(this.term);

  @override
  List<Object?> get props => [term];
}

/// Fired when the user submits a search (e.g. taps an item or presses enter).
/// Adds the term to the top of recent searches.
class SearchSubmitted extends SearchEvent {
  final String term;
  const SearchSubmitted(this.term);

  @override
  List<Object?> get props => [term];
}
