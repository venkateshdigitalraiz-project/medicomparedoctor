import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/searchAppointment/bloc/appointment_today_search_event.dart';
import 'package:medicompare/searchAppointment/bloc/appointment_today_search_state.dart';
import 'package:medicompare/searchAppointment/model/appointment_model.dart';

class AppointmentTodaySearchBloc
    extends Bloc<AppointmentTodaySearchEvent, AppointmentTodaySearchState> {
  AppointmentTodaySearchBloc() : super(const AppointmentTodaySearchState()) {
    on<AppointmentTodaySearchStarted>(_onStarted);
    on<AppointmentTodaySearchQueryChanged>(_onQueryChanged);
    on<AppointmentTodaySearchAppointmentRemoved>(_onAppointmentRemoved);
  }
  //AppointmentTodaySearchBloc
  Future<void> _onStarted(
    AppointmentTodaySearchStarted event,
    Emitter<AppointmentTodaySearchState> emit,
  ) async {
    emit(state.copyWith(status: AppointmentTodaySearchStatus.loading));
    try {
      // Replace this with a real repository/API call.
      final appointments = _mockAppointments();
      emit(
        state.copyWith(
          status: AppointmentTodaySearchStatus.success,
          allAppointments: appointments,
          filteredAppointments: appointments,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentTodaySearchStatus.failure,
          errorMessage: 'Could not load today\'s appointments.',
        ),
      );
    }
  }

  void _onQueryChanged(
    AppointmentTodaySearchQueryChanged event,
    Emitter<AppointmentTodaySearchState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.allAppointments
        : state.allAppointments.where((appointment) {
            return appointment.name.toLowerCase().contains(query) ||
                appointment.phone.toLowerCase().contains(query) ||
                appointment.id.toLowerCase().contains(query);
          }).toList();

    emit(state.copyWith(query: event.query, filteredAppointments: filtered));
  }

  void _onAppointmentRemoved(
    AppointmentTodaySearchAppointmentRemoved event,
    Emitter<AppointmentTodaySearchState> emit,
  ) {
    final updatedAll = state.allAppointments
        .where((appointment) => appointment.id != event.appointmentId)
        .toList();
    final updatedFiltered = state.filteredAppointments
        .where((appointment) => appointment.id != event.appointmentId)
        .toList();

    emit(
      state.copyWith(
        allAppointments: updatedAll,
        filteredAppointments: updatedFiltered,
      ),
    );
  }

  List<Appointment> _mockAppointments() {
    return const [
      Appointment(
        id: '1',
        name: 'Robert Fox',
        phone: '+1 555 010 1234',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
      ),
      Appointment(
        id: '2',
        name: 'Fathima',
        phone: '+1 555 010 5678',
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
      ),
      Appointment(
        id: '3',
        name: 'Lakshmi',
        phone: '+1 555 010 9012',
        avatarUrl: 'https://i.pravatar.cc/150?img=47',
      ),
    ];
  }
}
