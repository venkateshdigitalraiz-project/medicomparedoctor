part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the small edit/pencil icon next to the month header is tapped.
/// This is the ONLY trigger that opens the calendar month-grid popup.
class ToggleCalendarPopup extends CalendarEvent {
  const ToggleCalendarPopup();
}

/// Fired when the popup is dismissed (backdrop tap / close button).
class CloseCalendarPopup extends CalendarEvent {
  const CloseCalendarPopup();
}

/// Fired when the user taps a day inside the popup calendar grid.
class SelectDate extends CalendarEvent {
  final DateTime date;
  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Fired to move the popup calendar to the previous/next month.
class ChangeMonth extends CalendarEvent {
  final int monthDelta; // -1 or +1
  const ChangeMonth(this.monthDelta);

  @override
  List<Object?> get props => [monthDelta];
}
