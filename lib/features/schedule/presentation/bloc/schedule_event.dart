import 'dart:async';
import 'package:equatable/equatable.dart';
import '../../data/models/appointment.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchedule extends ScheduleEvent {
  const LoadSchedule();
}

class RefreshSchedule extends ScheduleEvent {
  final Completer<void>? completer;
  const RefreshSchedule({this.completer});

  @override
  List<Object?> get props => [completer];
}

class SelectCalendarDay extends ScheduleEvent {
  final CalendarDay day;
  const SelectCalendarDay(this.day);

  @override
  List<Object?> get props => [day];
}

class LoadNextSchedulePage extends ScheduleEvent {
  const LoadNextSchedulePage();
}

class JumpToToday extends ScheduleEvent {
  const JumpToToday();
}
