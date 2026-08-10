import 'package:equatable/equatable.dart';
import 'package:medicompare/features/today_appointment/presentation/screens/appointment.dart';

enum AppointmentStatusFlag { initial, loading, success, failure }

class AppointmentState extends Equatable {
  final AppointmentStatusFlag status;
  final List<Appointment> allAppointments;
  final List<Appointment> visibleAppointments;
  final String searchQuery;
  final String? selectedDate;
  final String? errorMessage;

  const AppointmentState({
    this.status = AppointmentStatusFlag.initial,
    this.allAppointments = const [],
    this.visibleAppointments = const [],
    this.searchQuery = '',
    this.selectedDate,
    this.errorMessage,
  });

  AppointmentState copyWith({
    AppointmentStatusFlag? status,
    List<Appointment>? allAppointments,
    List<Appointment>? visibleAppointments,
    String? searchQuery,
    String? selectedDate,
    String? errorMessage,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      allAppointments: allAppointments ?? this.allAppointments,
      visibleAppointments: visibleAppointments ?? this.visibleAppointments,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allAppointments,
    visibleAppointments,
    searchQuery,
    selectedDate,
    errorMessage,
  ];
}
