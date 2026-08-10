import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/calendar/data/models/timeline_event.dart';
import 'package:medicompare/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:medicompare/features/calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarState.initial()) {
    on<CalendarStarted>(_onStarted);
    on<DateSelected>(_onDateSelected);
    on<PreviousMonthRequested>(_onPreviousMonth);
    on<NextMonthRequested>(_onNextMonth);
    on<AvailabilityEditRequested>(_onAvailabilityEdit);
  }

  Future<void> _onStarted(
      CalendarStarted event, Emitter<CalendarState> emit) async {
    // Simulate a data fetch (e.g. from an API/repository).
    await Future.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(
      isLoading: false,
      markers: const [
        DateMarker(5, DateMarkerType.busy),
        DateMarker(11, DateMarkerType.busy),
        DateMarker(19, DateMarkerType.busy),
        DateMarker(26, DateMarkerType.busy),
        DateMarker(17, DateMarkerType.holiday),
        DateMarker(29, DateMarkerType.holiday),
      ],
      timeline: const [
        TimelineEvent(
          name: 'Sarah Johnson',
          id: 'SJ-456789',
          time: '09:00 AM',
          date: '05 JULY 2026',
          subtitle: 'Video call',
          avatarUrl:
              'https://i.pravatar.cc/150?img=47',
          accentColor: Color(0xFF7C3AED),
        ),
        TimelineEvent(
          name: 'Sarah Johnson',
          id: 'SJ-456789',
          time: '09:00 AM',
          date: '05 JULY 2026',
          subtitle: 'Video call',
          avatarUrl:
              'https://i.pravatar.cc/150?img=47',
          accentColor: Color(0xFF22C55E),
        ),
        TimelineEvent(
          name: 'Sarah Johnson',
          id: 'SJ-456789',
          time: '09:00 AM',
          date: '05 JULY 2026',
          subtitle: 'Video call',
          avatarUrl:
              'https://i.pravatar.cc/150?img=47',
          accentColor: Color(0xFF3B82F6),
        ),
      ],
    ));
  }

  void _onDateSelected(DateSelected event, Emitter<CalendarState> emit) {
    emit(state.copyWith(selectedDay: event.day));
  }

  void _onPreviousMonth(
      PreviousMonthRequested event, Emitter<CalendarState> emit) {
    int month = state.month - 1;
    int year = state.year;
    if (month < 1) {
      month = 12;
      year -= 1;
    }
    emit(state.copyWith(month: month, year: year));
  }

  void _onNextMonth(NextMonthRequested event, Emitter<CalendarState> emit) {
    int month = state.month + 1;
    int year = state.year;
    if (month > 12) {
      month = 1;
      year += 1;
    }
    emit(state.copyWith(month: month, year: year));
  }

  void _onAvailabilityEdit(
      AvailabilityEditRequested event, Emitter<CalendarState> emit) {
    // Hook up navigation to an edit-availability screen here.
  }
}
