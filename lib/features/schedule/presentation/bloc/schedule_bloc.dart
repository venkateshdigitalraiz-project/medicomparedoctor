import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/appointment.dart';
import '../../data/repositories/schedule_repository.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository _repository;
  static const int _limit = 10;

  ScheduleBloc({ScheduleRepository? repository})
      : _repository = repository ?? ScheduleRepositoryImpl(),
        super(ScheduleState.initial()) {
    on<LoadSchedule>(_onLoadSchedule);
    on<RefreshSchedule>(_onRefreshSchedule);
    on<SelectCalendarDay>(_onSelectCalendarDay);
    on<LoadNextSchedulePage>(_onLoadNextSchedulePage);
    on<JumpToToday>(_onJumpToToday);
  }

  Future<void> _onLoadSchedule(
      LoadSchedule event, Emitter<ScheduleState> emit) async {
    if (state.status == ScheduleStatus.initialLoading) return;
    emit(state.copyWith(status: ScheduleStatus.initialLoading));
    await _fetchData(emit, page: 1, reset: true);
  }

  Future<void> _onRefreshSchedule(
      RefreshSchedule event, Emitter<ScheduleState> emit) async {
    if (state.status == ScheduleStatus.refreshing || state.status == ScheduleStatus.initialLoading) return;
    emit(state.copyWith(status: ScheduleStatus.refreshing));
    await _fetchData(emit, page: 1, reset: true);
  }

  Future<void> _onSelectCalendarDay(
      SelectCalendarDay event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(
      selectedDateString: event.day.dateString,
      selectedDayDate: event.day.date,
    ));
  }

  Future<void> _onLoadNextSchedulePage(
      LoadNextSchedulePage event, Emitter<ScheduleState> emit) async {
    if (state.isLoadingNextPage) return;
    if (state.hasReachedEnd) return;

    emit(state.copyWith(isLoadingNextPage: true));
    await _fetchData(
      emit,
      page: state.currentPage + 1,
      reset: false,
      skipCalendarUpdate: true,
    );
  }

  Future<void> _onJumpToToday(
      JumpToToday event, Emitter<ScheduleState> emit) async {
    if (state.status == ScheduleStatus.initialLoading) return;
    emit(state.copyWith(status: ScheduleStatus.initialLoading));
    await _fetchData(emit, page: 1, reset: true);
  }

  Future<void> _fetchData(
    Emitter<ScheduleState> emit, {
    required int page,
    required bool reset,
    String? date,
    bool skipCalendarUpdate = false,
  }) async {
    try {
      final response = await _repository.fetchSchedule(
        page: page,
        limit: _limit,
        date: date,
      );

      final newAppts = reset
          ? response.appointments.list
          : [...state.appointments, ...response.appointments.list];

      // De-duplicate appointments by id
      final seen = <String>{};
      final deduped = newAppts.where((a) => seen.add(a.id)).toList();

      final hasReachedEnd = response.appointments.totalPages == 0 ||
          response.appointments.page >= response.appointments.totalPages;

      // Find the currently selected date's details from calendar
      String? selectedDateStr = state.selectedDateString;
      int selectedDayDt = state.selectedDayDate;

      // If resetting and selectedDateString is null/empty, look up calendar to highlight
      if (reset && (selectedDateStr == null || selectedDateStr.isEmpty)) {
        if (response.appointments.list.isNotEmpty) {
          final firstTime = response.appointments.list.first.time;
          try {
            final parsedDate = DateTime.parse(firstTime);
            selectedDateStr = "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
          } catch (_) {
            if (response.calendar.isNotEmpty) {
              selectedDateStr = response.calendar.first.dateString;
            }
          }
        } else if (response.calendar.isNotEmpty) {
          selectedDateStr = response.calendar.first.dateString;
        }
      }

      if (selectedDateStr != null && selectedDateStr.isNotEmpty) {
        final match = response.calendar.firstWhere(
          (d) => d.dateString == selectedDateStr,
          orElse: () => CalendarDay(
            dayName: '',
            date: 0,
            count: 0,
            dateString: selectedDateStr!,
          ),
        );
        selectedDayDt = match.date;
      }

      // Check if calendar should be updated or kept
      bool shouldUpdateCalendar = !skipCalendarUpdate;
      if (skipCalendarUpdate && state.calendar.isEmpty) {
        shouldUpdateCalendar = true;
      }
      
      // Also force calendar update if the month/year of the returned calendar differs from state
      if (!shouldUpdateCalendar && response.calendar.isNotEmpty && state.calendar.isNotEmpty) {
        try {
          final newMonth = DateTime.parse(response.calendar.first.dateString).month;
          final oldMonth = DateTime.parse(state.calendar.first.dateString).month;
          if (newMonth != oldMonth) {
            shouldUpdateCalendar = true;
          }
        } catch (_) {}
      }

      final finalStatus = deduped.isEmpty ? ScheduleStatus.empty : ScheduleStatus.success;

      emit(state.copyWith(
        status: finalStatus,
        calendar: shouldUpdateCalendar ? response.calendar : state.calendar,
        stats: response.summary,
        appointments: deduped,
        selectedDateString: selectedDateStr,
        selectedDayDate: selectedDayDt,
        currentPage: response.appointments.page,
        totalPages: response.appointments.totalPages,
        hasReachedEnd: hasReachedEnd,
        isLoadingNextPage: false,
        isAppointmentsLoading: false,
        clearError: true,
      ));
    } catch (e, stack) {
      developer.log('Error in _fetchData: $e', stackTrace: stack, name: 'ScheduleBloc');
      if (reset) {
        emit(state.copyWith(
          status: ScheduleStatus.failure,
          errorMessage: e.toString(),
          isLoadingNextPage: false,
          isAppointmentsLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoadingNextPage: false,
          isAppointmentsLoading: false,
          errorMessage: 'Could not load more appointments.',
        ));
      }
    }
  }
}
