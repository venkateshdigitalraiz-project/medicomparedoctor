import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen first loads.
class LoadSchedule extends ScheduleEvent {
  const LoadSchedule();
}

/// Fired when the user taps a different day chip in the date strip.
class SelectDate extends ScheduleEvent {
  final DateTime date;
  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Fired when the user taps "Today".
class JumpToToday extends ScheduleEvent {
  const JumpToToday();
}
