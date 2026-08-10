import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen first loads.
class CalendarStarted extends CalendarEvent {
  const CalendarStarted();
}

/// User tapped a specific day cell in the grid.
class DateSelected extends CalendarEvent {
  final int day;

  const DateSelected(this.day);

  @override
  List<Object?> get props => [day];
}

/// User moved to the previous month.
class PreviousMonthRequested extends CalendarEvent {
  const PreviousMonthRequested();
}

/// User moved to the next month.
class NextMonthRequested extends CalendarEvent {
  const NextMonthRequested();
}

/// User tapped "Edit" on the availability card.
class AvailabilityEditRequested extends CalendarEvent {
  const AvailabilityEditRequested();
}
