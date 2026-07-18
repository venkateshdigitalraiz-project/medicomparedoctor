import 'package:equatable/equatable.dart';
import '../models/appointment.dart';

enum ScheduleStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  final ScheduleStatus status;
  final DateTime selectedDate;
  final List<DateTime> visibleWeek;
  final ScheduleStats stats;
  final List<Appointment> appointments;
  final String? errorMessage;

  const ScheduleState({
    this.status = ScheduleStatus.initial,
    required this.selectedDate,
    this.visibleWeek = const [],
    this.stats = const ScheduleStats(total: 0, confirmed: 0, waiting: 0, cancelled: 0),
    this.appointments = const [],
    this.errorMessage,
  });

  factory ScheduleState.initial() => ScheduleState(selectedDate: DateTime.now());

  ScheduleState copyWith({
    ScheduleStatus? status,
    DateTime? selectedDate,
    List<DateTime>? visibleWeek,
    ScheduleStats? stats,
    List<Appointment>? appointments,
    String? errorMessage,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      visibleWeek: visibleWeek ?? this.visibleWeek,
      stats: stats ?? this.stats,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, selectedDate, visibleWeek, stats, appointments, errorMessage];
}
