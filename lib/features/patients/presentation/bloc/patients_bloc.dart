import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/patient.dart';
import '../../data/models/patient_filter.dart';
import 'patients_event.dart';
import '../../domain/repositories/patients_repository.dart';
import 'patients_state.dart';

class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  final PatientsRepository repository;

  PatientsBloc({required this.repository}) : super(const PatientsState()) {
    on<PatientsLoadRequested>(_onLoadRequested);
    on<PatientsLoadMoreRequested>(_onLoadMoreRequested);
    on<PatientsFilterChanged>(_onFilterChanged);
    on<PatientsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoadRequested(
    PatientsLoadRequested event,
    Emitter<PatientsState> emit,
  ) async {
    // If it's the initial load, show the main loader. If it's a refresh, keep the UI state
    emit(state.copyWith(
      status: PatientsStatus.loading,
      errorMessage: null,
    ));
    try {
      final response = await repository.fetchPatients(page: 1, limit: state.limit);
      
      emit(state.copyWith(
        status: PatientsStatus.success,
        allPatients: response.patients,
        visiblePatients: _applyFilters(
          filter: state.activeFilter,
          query: state.searchQuery,
          patientsList: response.patients,
        ),
        page: response.pagination.page,
        totalPages: response.pagination.totalPages,
        total: response.pagination.total,
        limit: response.pagination.limit,
        totalPatients: response.statistics.totalPatients,
        newThisMonth: response.statistics.newThisMonth,
        waitingPatientsCount: response.statistics.waiting,
        completedPatientsCount: response.statistics.completed,
        cancelledPatientsCount: response.statistics.cancelled,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PatientsStatus.failure,
        errorMessage: e.toString(),
      ));
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onLoadMoreRequested(
    PatientsLoadMoreRequested event,
    Emitter<PatientsState> emit,
  ) async {
    if (state.isLoadingMore ||
        state.status == PatientsStatus.loading ||
        state.page >= state.totalPages) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final response = await repository.fetchPatients(page: nextPage, limit: state.limit);

      // Prevent duplicate patient records based on their ID
      final existingIds = state.allPatients.map((p) => p.id).toSet();
      final newPatients = response.patients
          .where((p) => !existingIds.contains(p.id))
          .toList();

      final updatedAllPatients = List<Patient>.from(state.allPatients)..addAll(newPatients);

      emit(state.copyWith(
        status: PatientsStatus.success,
        isLoadingMore: false,
        allPatients: updatedAllPatients,
        visiblePatients: _applyFilters(
          filter: state.activeFilter,
          query: state.searchQuery,
          patientsList: updatedAllPatients,
        ),
        page: response.pagination.page,
        totalPages: response.pagination.totalPages,
        total: response.pagination.total,
        limit: response.pagination.limit,
        totalPatients: response.statistics.totalPatients,
        newThisMonth: response.statistics.newThisMonth,
        waitingPatientsCount: response.statistics.waiting,
        completedPatientsCount: response.statistics.completed,
        cancelledPatientsCount: response.statistics.cancelled,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        status: PatientsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onFilterChanged(
    PatientsFilterChanged event,
    Emitter<PatientsState> emit,
  ) {
    emit(state.copyWith(
      activeFilter: event.filter,
      visiblePatients: _applyFilters(
        filter: event.filter,
        query: state.searchQuery,
        patientsList: state.allPatients,
      ),
    ));
  }

  void _onSearchChanged(
    PatientsSearchChanged event,
    Emitter<PatientsState> emit,
  ) {
    emit(state.copyWith(
      searchQuery: event.query,
      visiblePatients: _applyFilters(
        filter: state.activeFilter,
        query: event.query,
        patientsList: state.allPatients,
      ),
    ));
  }

  List<Patient> _applyFilters({
    required PatientFilter filter,
    required String query,
    required List<Patient> patientsList,
  }) {
    return patientsList.where((p) {
      final matchesFilter = switch (filter) {
        PatientFilter.all => true,
        PatientFilter.completed => p.status == PatientStatus.completed,
        PatientFilter.waiting => p.status == PatientStatus.waiting,
        PatientFilter.cancelled => p.status == PatientStatus.cancelled,
      };
      final matchesSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.pid.toLowerCase().contains(query.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }
}
