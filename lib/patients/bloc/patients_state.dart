import 'package:equatable/equatable.dart';
import '../models/patient.dart';
import '../models/patient_filter.dart';

enum PatientsStatus { initial, loading, success, failure }

class PatientsState extends Equatable {
  final PatientsStatus status;
  final List<Patient> allPatients;
  final List<Patient> visiblePatients;
  final PatientFilter activeFilter;
  final String searchQuery;
  final int newThisMonth;
  final String? errorMessage;

  const PatientsState({
    this.status = PatientsStatus.initial,
    this.allPatients = const [],
    this.visiblePatients = const [],
    this.activeFilter = PatientFilter.all,
    this.searchQuery = '',
    this.newThisMonth = 0,
    this.errorMessage,
  });

  // ---- Derived counters used by the stat cards at the top of the screen ----
  int get totalCount => allPatients.length;
  int get waitingCount =>
      allPatients.where((p) => p.status == PatientStatus.waiting).length;
  int get cancelledCount =>
      allPatients.where((p) => p.status == PatientStatus.cancelled).length;

  PatientsState copyWith({
    PatientsStatus? status,
    List<Patient>? allPatients,
    List<Patient>? visiblePatients,
    PatientFilter? activeFilter,
    String? searchQuery,
    int? newThisMonth,
    String? errorMessage,
  }) {
    return PatientsState(
      status: status ?? this.status,
      allPatients: allPatients ?? this.allPatients,
      visiblePatients: visiblePatients ?? this.visiblePatients,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      newThisMonth: newThisMonth ?? this.newThisMonth,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allPatients,
        visiblePatients,
        activeFilter,
        searchQuery,
        newThisMonth,
        errorMessage,
      ];
}
