import 'package:equatable/equatable.dart';

import 'package:medicompare/searchAppointment/model/appointment_model.dart';

enum AppointmentTodaySearchStatus { initial, loading, success, failure }

class AppointmentTodaySearchState extends Equatable {
  final AppointmentTodaySearchStatus status;
  final List<Appointment> allAppointments;
  final List<Appointment> filteredAppointments;
  final String query;
  final String? errorMessage;

  const AppointmentTodaySearchState({
    this.status = AppointmentTodaySearchStatus.initial,
    this.allAppointments = const [],
    this.filteredAppointments = const [],
    this.query = '',
    this.errorMessage,
  });

  AppointmentTodaySearchState copyWith({
    AppointmentTodaySearchStatus? status,
    List<Appointment>? allAppointments,
    List<Appointment>? filteredAppointments,
    String? query,
    String? errorMessage,
  }) {
    return AppointmentTodaySearchState(
      status: status ?? this.status,
      allAppointments: allAppointments ?? this.allAppointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allAppointments,
    filteredAppointments,
    query,
    errorMessage,
  ];
}
