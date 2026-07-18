import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/patient.dart';
import '../models/patient_filter.dart';
import 'patients_event.dart';
import 'patients_repository.dart';
import 'patients_state.dart';

class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  final PatientsRepository repository;

  PatientsBloc({required this.repository}) : super(const PatientsState()) {
    on<PatientsLoadRequested>(_onLoadRequested);
    on<PatientsFilterChanged>(_onFilterChanged);
    on<PatientsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoadRequested(
    PatientsLoadRequested event,
    Emitter<PatientsState> emit,
  ) async {
    emit(state.copyWith(status: PatientsStatus.loading));
    try {
      final patients = await repository.fetchPatients();
      emit(state.copyWith(
        status: PatientsStatus.success,
        allPatients: patients,
        visiblePatients: patients,
        newThisMonth: 2, // sample metric, wire to real data as needed
      ));
    } catch (e) {
      emit(state.copyWith(
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
      ),
    ));
  }

  List<Patient> _applyFilters({
    required PatientFilter filter,
    required String query,
  }) {
    return state.allPatients.where((p) {
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
