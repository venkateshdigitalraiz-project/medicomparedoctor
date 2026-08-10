import 'package:equatable/equatable.dart';

abstract class AppointmentTodaySearchEvent extends Equatable {
  const AppointmentTodaySearchEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen is first opened, to load today's
/// appointment list.
class AppointmentTodaySearchStarted extends AppointmentTodaySearchEvent {
  const AppointmentTodaySearchStarted();
}

/// Fired whenever the text in the search field changes.
class AppointmentTodaySearchQueryChanged extends AppointmentTodaySearchEvent {
  final String query;

  const AppointmentTodaySearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Fired when the user taps the "X" icon next to an appointment
/// to remove it from today's list.
class AppointmentTodaySearchAppointmentRemoved
    extends AppointmentTodaySearchEvent {
  final String appointmentId;

  const AppointmentTodaySearchAppointmentRemoved(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Fired when the user taps the calendar icon button.
class AppointmentTodaySearchCalendarTapped
    extends AppointmentTodaySearchEvent {
  const AppointmentTodaySearchCalendarTapped();
}
