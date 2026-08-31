import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/appointment_details/data/models/appointment_model.dart';
import 'package:medicompare/features/appointment_details/presentation/bloc/appointment_event.dart';
import 'package:medicompare/features/appointment_details/presentation/bloc/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(const AppointmentLoading()) {
    on<LoadAppointmentDetails>(_onLoadAppointmentDetails);
    on<ContactActionPressed>(_onContactActionPressed);
  }

  Future<void> _onLoadAppointmentDetails(
    LoadAppointmentDetails event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoading());

    // Simulate a network / repository call.
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final appointment = _fetchMockAppointment(event.appointmentId);
      emit(AppointmentLoaded(appointment));
    } catch (e) {
      emit(AppointmentError('Failed to load appointment: $e'));
    }
  }

  void _onContactActionPressed(
    ContactActionPressed event,
    Emitter<AppointmentState> emit,
  ) {
    final currentState = state;
    if (currentState is AppointmentLoaded) {
      final label = switch (event.action) {
        ContactAction.call => 'Calling patient…',
        ContactAction.video => 'Starting video call…',
        ContactAction.chat => 'Opening chat…',
      };
      emit(currentState.copyWith(lastActionMessage: label));
    }
  }

  AppointmentModel _fetchMockAppointment(String appointmentId) {
    return AppointmentModel(
      id: appointmentId,
      patientName: 'Emily Chen',
      patientId: 'MC-789019',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      type: 'Follow-Up',
      appointmentTime: '5:30 AM',
      surgeryType: 'Aortic Valve Replacement',
      location: 'Main OR - Wing B',
      reasonForCheckup: 'Routine Check-up',
      appointmentType: 'Online',
      duration: '15 Minutes',
      clinicalNotes: [
        'Monitor blood pressure levels every 4 hours.',
        'Pre-surgery fasting starts at 12:00 AM.',
      ],
      timeline: [
        TimelineEvent(title: 'Booked', time: '08:00 AM'),
        TimelineEvent(title: 'Confirmed', time: '08:15 AM'),
        TimelineEvent(title: 'Checked In', time: '09:20 AM'),
        TimelineEvent(title: 'Pending', time: '--:--', isPending: true),
      ],
    );
  }
}
