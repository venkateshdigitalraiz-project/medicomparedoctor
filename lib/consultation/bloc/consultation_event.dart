part of 'consultation_bloc.dart';

abstract class ConsultationEvent extends Equatable {
  const ConsultationEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen first loads, to fetch the initial list.
class LoadConsultations extends ConsultationEvent {
  const LoadConsultations();
}

/// Fired whenever the search field changes.
class SearchQueryChanged extends ConsultationEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Fired when the user taps a filter tab (All / Today / Video / Audio / In-clinic).
class FilterTabChanged extends ConsultationEvent {
  final ConsultationFilter filter;
  const FilterTabChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
