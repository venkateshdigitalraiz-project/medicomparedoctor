import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the screen first loads to fetch the appointment list.
class LoadAppointments extends AppointmentEvent {
  const LoadAppointments();
}

/// Fired whenever the search text changes.
class SearchAppointments extends AppointmentEvent {
  final String query;

  const SearchAppointments(this.query);

  @override
  List<Object?> get props => [query];
}

/// Fired when the calendar icon is tapped (placeholder for a date filter).
class FilterByDate extends AppointmentEvent {
  final String? date;

  const FilterByDate(this.date);

  @override
  List<Object?> get props => [date];
}
