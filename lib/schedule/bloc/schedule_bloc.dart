import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/appointment.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleState.initial()) {
    on<LoadSchedule>(_onLoadSchedule);
    on<SelectDate>(_onSelectDate);
    on<JumpToToday>(_onJumpToToday);
  }

  Future<void> _onLoadSchedule(
      LoadSchedule event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final week = _buildWeek(state.selectedDate);
      final appts = _mockAppointmentsFor(state.selectedDate);
      emit(state.copyWith(
        status: ScheduleStatus.success,
        visibleWeek: week,
        appointments: appts,
        stats: _computeStats(appts),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ScheduleStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSelectDate(
      SelectDate event, Emitter<ScheduleState> emit) async {
    final appts = _mockAppointmentsFor(event.date);
    emit(state.copyWith(
      selectedDate: event.date,
      appointments: appts,
      stats: _computeStats(appts),
    ));
  }

  Future<void> _onJumpToToday(
      JumpToToday event, Emitter<ScheduleState> emit) async {
    final today = DateTime.now();
    final week = _buildWeek(today);
    final appts = _mockAppointmentsFor(today);
    emit(state.copyWith(
      selectedDate: today,
      visibleWeek: week,
      appointments: appts,
      stats: _computeStats(appts),
    ));
  }

  /// Builds the Mon–Sat strip that contains [anchor].
  List<DateTime> _buildWeek(DateTime anchor) {
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    return List.generate(6, (i) => monday.add(Duration(days: i)));
  }

  ScheduleStats _computeStats(List<Appointment> appts) {
    final confirmed =
        appts.where((a) => a.status == AppointmentStatus.confirmed).length;
    final waiting =
        appts.where((a) => a.status == AppointmentStatus.waiting).length;
    final cancelled =
        appts.where((a) => a.status == AppointmentStatus.cancelled).length;
    return ScheduleStats(
      total: appts.length,
      confirmed: confirmed,
      waiting: waiting,
      cancelled: cancelled,
    );
  }

  /// Replace this with a real repository/API call.
  List<Appointment> _mockAppointmentsFor(DateTime date) {
    return const [
      Appointment(
        id: '1',
        patientName: 'Robert Fox',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        time: '09:00 AM',
        mode: AppointmentMode.inPerson,
        status: AppointmentStatus.confirmed,
      ),
      Appointment(
        id: '2',
        patientName: 'Bessie Cooper',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        time: '10:30 AM',
        mode: AppointmentMode.online,
        status: AppointmentStatus.waiting,
        meetingLink: 'meet.google.com/abc-xyz',
      ),
      Appointment(
        id: '3',
        patientName: 'Sarah Johnson',
        avatarUrl: 'https://i.pravatar.cc/150?img=9',
        time: '11:45 AM',
        mode: AppointmentMode.inPerson,
        status: AppointmentStatus.confirmed,
      ),
      Appointment(
        id: '4',
        patientName: 'Michael Smith',
        avatarUrl: 'https://i.pravatar.cc/150?img=15',
        time: '01:30 PM',
        mode: AppointmentMode.linkExpired,
        status: AppointmentStatus.cancelled,
      ),
      Appointment(
        id: '5',
        patientName: 'Robert Fox',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        time: '03:00 PM',
        mode: AppointmentMode.inPerson,
        status: AppointmentStatus.confirmed,
      ),
    ];
  }
}
