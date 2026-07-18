import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/consultation/screen/consultation.dart';
import 'package:medicompare/consultation/screen/mock_data.dart';

part 'consultation_event.dart';
part 'consultation_state.dart';

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  ConsultationBloc() : super(const ConsultationState()) {
    on<LoadConsultations>(_onLoad);
    on<SearchQueryChanged>(_onSearchChanged);
    on<FilterTabChanged>(_onFilterChanged);
  }

  Future<void> _onLoad(
    LoadConsultations event,
    Emitter<ConsultationState> emit,
  ) async {
    emit(state.copyWith(status: ConsultationStatusFlag.loading));

    // Simulate a network / repository call.
    await Future.delayed(const Duration(milliseconds: 300));

    emit(
      state.copyWith(
        status: ConsultationStatusFlag.loaded,
        allConsultations: mockConsultations,
        visibleConsultations: mockConsultations,
      ),
    );
  }

  void _onSearchChanged(
    SearchQueryChanged event,
    Emitter<ConsultationState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        visibleConsultations: _applyFilters(
          query: event.query,
          filter: state.selectedFilter,
        ),
      ),
    );
  }

  void _onFilterChanged(
    FilterTabChanged event,
    Emitter<ConsultationState> emit,
  ) {
    emit(
      state.copyWith(
        selectedFilter: event.filter,
        visibleConsultations: _applyFilters(
          query: state.searchQuery,
          filter: event.filter,
        ),
      ),
    );
  }

  List<Consultation> _applyFilters({
    required String query,
    required ConsultationFilter filter,
  }) {
    return state.allConsultations.where((c) {
      final matchesQuery =
          query.isEmpty ||
          c.patientName.toLowerCase().contains(query.toLowerCase()) ||
          c.id.toLowerCase().contains(query.toLowerCase());

      final matchesFilter = switch (filter) {
        ConsultationFilter.all => true,
        ConsultationFilter.today => c.isToday,
        ConsultationFilter.videoCall => c.type == ConsultationType.videoCall,
        ConsultationFilter.audioCall => c.type == ConsultationType.audioCall,
        ConsultationFilter.inClinic => c.type == ConsultationType.inClinic,
      };

      return matchesQuery && matchesFilter;
    }).toList();
  }
}
