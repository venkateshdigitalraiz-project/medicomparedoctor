import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/today_aptmnt/screen/appointment.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(const AppointmentState()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<SearchAppointments>(_onSearchAppointments);
    on<FilterByDate>(_onFilterByDate);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(status: AppointmentStatusFlag.loading));
    try {
      // Simulate a network / database call.
      await Future.delayed(const Duration(milliseconds: 400));
      final appointments = _mockAppointments();
      emit(
        state.copyWith(
          status: AppointmentStatusFlag.success,
          allAppointments: appointments,
          visibleAppointments: appointments,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentStatusFlag.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSearchAppointments(
    SearchAppointments event,
    Emitter<AppointmentState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? state.allAppointments
        : state.allAppointments
              .where(
                (a) =>
                    a.name.toLowerCase().contains(query) ||
                    a.id.toLowerCase().contains(query),
              )
              .toList();

    emit(
      state.copyWith(searchQuery: event.query, visibleAppointments: filtered),
    );
  }

  void _onFilterByDate(FilterByDate event, Emitter<AppointmentState> emit) {
    // Placeholder: wire this up to real date filtering when a backend exists.
    emit(state.copyWith(selectedDate: event.date));
  }

  List<Appointment> _mockAppointments() {
    return const [
      Appointment(
        id: 'A001',
        time: '09:30 AM',
        name: 'Marcus Williams',
        avatarUrl: 'https://i.pravatar.cc/150?img=13',
        status: AppointmentStatus.confirmed,
        type: AppointmentType.online,
      ),
      Appointment(
        id: 'A002',
        time: '10:15 AM',
        name: 'Sarah Jenkins',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        status: AppointmentStatus.waiting,
        type: AppointmentType.inPerson,
      ),
      Appointment(
        id: 'A003',
        time: '10:45 AM',
        name: 'Robert Fox',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        status: AppointmentStatus.confirmed,
        type: AppointmentType.online,
      ),
      Appointment(
        id: 'A004',
        time: '10:15 AM',
        name: 'Sarah Jenkins',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        status: AppointmentStatus.waiting,
        type: AppointmentType.inPerson,
      ),
      Appointment(
        id: 'A005',
        time: '09:30 AM',
        name: 'Marcus Williams',
        avatarUrl: 'https://i.pravatar.cc/150?img=13',
        status: AppointmentStatus.confirmed,
        type: AppointmentType.online,
      ),
      Appointment(
        id: 'A006',
        time: '10:45 AM',
        name: 'Robert Fox',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        status: AppointmentStatus.confirmed,
        type: AppointmentType.online,
      ),
    ];
  }
}
