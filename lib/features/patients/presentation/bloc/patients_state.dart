import 'package:equatable/equatable.dart';
import '../../data/models/patient.dart';
import '../../data/models/patient_filter.dart';

enum PatientsStatus { initial, loading, success, failure }

class PatientsState extends Equatable {
  final PatientsStatus status;
  final List<Patient> allPatients;
  final List<Patient> visiblePatients;
  final PatientFilter activeFilter;
  final String searchQuery;
  final String? errorMessage;

  // Pagination parameters
  final int page;
  final int totalPages;
  final int limit;
  final int total;
  final bool isLoadingMore;

  // Statistics counters (synced with the API)
  final int totalPatients;
  final int newThisMonth;
  final int waitingPatientsCount;
  final int completedPatientsCount;
  final int cancelledPatientsCount;

  const PatientsState({
    this.status = PatientsStatus.initial,
    this.allPatients = const [],
    this.visiblePatients = const [],
    this.activeFilter = PatientFilter.all,
    this.searchQuery = '',
    this.errorMessage,
    this.page = 1,
    this.totalPages = 1,
    this.limit = 10,
    this.total = 0,
    this.isLoadingMore = false,
    this.totalPatients = 0,
    this.newThisMonth = 0,
    this.waitingPatientsCount = 0,
    this.completedPatientsCount = 0,
    this.cancelledPatientsCount = 0,
  });

  // Keep these getters for compatibility with existing widgets
  int get totalCount => totalPatients;
  int get waitingCount => waitingPatientsCount;
  int get cancelledCount => cancelledPatientsCount;

  PatientsState copyWith({
    PatientsStatus? status,
    List<Patient>? allPatients,
    List<Patient>? visiblePatients,
    PatientFilter? activeFilter,
    String? searchQuery,
    String? errorMessage,
    int? page,
    int? totalPages,
    int? limit,
    int? total,
    bool? isLoadingMore,
    int? totalPatients,
    int? newThisMonth,
    int? waitingPatientsCount,
    int? completedPatientsCount,
    int? cancelledPatientsCount,
  }) {
    return PatientsState(
      status: status ?? this.status,
      allPatients: allPatients ?? this.allPatients,
      visiblePatients: visiblePatients ?? this.visiblePatients,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalPatients: totalPatients ?? this.totalPatients,
      newThisMonth: newThisMonth ?? this.newThisMonth,
      waitingPatientsCount: waitingPatientsCount ?? this.waitingPatientsCount,
      completedPatientsCount: completedPatientsCount ?? this.completedPatientsCount,
      cancelledPatientsCount: cancelledPatientsCount ?? this.cancelledPatientsCount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allPatients,
        visiblePatients,
        activeFilter,
        searchQuery,
        errorMessage,
        page,
        totalPages,
        limit,
        total,
        isLoadingMore,
        totalPatients,
        newThisMonth,
        waitingPatientsCount,
        completedPatientsCount,
        cancelledPatientsCount,
      ];
}
