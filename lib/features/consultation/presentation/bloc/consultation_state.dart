part of 'consultation_bloc.dart';

/// Which tab is currently selected.
enum ConsultationFilter { all, today, videoCall, audioCall, inClinic }

enum ConsultationStatusFlag { initial, loading, loaded }

class ConsultationState extends Equatable {
  final ConsultationStatusFlag status;
  final List<Consultation> allConsultations;
  final List<Consultation> visibleConsultations;
  final String searchQuery;
  final ConsultationFilter selectedFilter;

  const ConsultationState({
    this.status = ConsultationStatusFlag.initial,
    this.allConsultations = const [],
    this.visibleConsultations = const [],
    this.searchQuery = '',
    this.selectedFilter = ConsultationFilter.all,
  });

  // ---- Derived summary counters shown in the stats row ----
  int get totalCount => allConsultations.length;
  int get doneCount =>
      allConsultations.where((c) => c.status == ConsultationStatus.done).length;
  int get upcomingCount => allConsultations
      .where((c) => c.status == ConsultationStatus.upcoming)
      .length;
  int get cancelledCount => allConsultations
      .where((c) => c.status == ConsultationStatus.cancelled)
      .length;

  ConsultationState copyWith({
    ConsultationStatusFlag? status,
    List<Consultation>? allConsultations,
    List<Consultation>? visibleConsultations,
    String? searchQuery,
    ConsultationFilter? selectedFilter,
  }) {
    return ConsultationState(
      status: status ?? this.status,
      allConsultations: allConsultations ?? this.allConsultations,
      visibleConsultations: visibleConsultations ?? this.visibleConsultations,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allConsultations,
    visibleConsultations,
    searchQuery,
    selectedFilter,
  ];
}
