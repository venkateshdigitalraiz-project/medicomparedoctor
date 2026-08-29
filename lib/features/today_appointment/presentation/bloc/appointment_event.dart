import 'dart:async';
import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodayAppointments extends AppointmentEvent {
  final Completer<void>? completer;

  const LoadTodayAppointments({this.completer});

  @override
  List<Object?> get props => [completer];
}

class LoadMoreTodayAppointments extends AppointmentEvent {
  const LoadMoreTodayAppointments();
}

class SearchTodayAppointments extends AppointmentEvent {
  final String query;

  const SearchTodayAppointments(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterTodayAppointmentsByStatus extends AppointmentEvent {
  final String? status;

  const FilterTodayAppointmentsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class FilterByDate extends AppointmentEvent {
  final String? date;

  const FilterByDate(this.date);

  @override
  List<Object?> get props => [date];
}
