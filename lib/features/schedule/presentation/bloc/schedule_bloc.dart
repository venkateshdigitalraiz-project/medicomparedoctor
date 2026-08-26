import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/ui/dialog_helper.dart';

import 'package:medicompare/features/schedule/data/models/appointment.dart';
import 'package:medicompare/features/schedule/data/repositories/schedule_repository.dart';
import 'package:medicompare/features/schedule/domain/usecases/get_schedule_usecase.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetScheduleUseCase _getScheduleUseCase;

  static const int _limit = 10;

  ScheduleBloc({GetScheduleUseCase? getScheduleUseCase})
    : _getScheduleUseCase =
          getScheduleUseCase ?? GetScheduleUseCase(ScheduleRepositoryImpl()),
      super(ScheduleState.initial()) {
    on<LoadSchedule>(_onLoadSchedule);
    on<RefreshSchedule>(_onRefreshSchedule);
    on<SelectCalendarDay>(_onSelectCalendarDay);
    on<LoadNextSchedulePage>(_onLoadNextSchedulePage);
    on<JumpToToday>(_onJumpToToday);
  }

  // ---------------------------------------------------------------------------
  // INITIAL LOAD
  // ---------------------------------------------------------------------------

  Future<void> _onLoadSchedule(
    LoadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.status == ScheduleStatus.initialLoading) {
      return;
    }

    DialogHelper.isAtLoginScreen = false;

    emit(
      state.copyWith(
        status: ScheduleStatus.initialLoading,
        clearError: true,
        isAppointmentsLoading: true,
      ),
    );

    await _fetchData(emit, page: 1, reset: true);
  }

  // ---------------------------------------------------------------------------
  // PULL TO REFRESH
  // ---------------------------------------------------------------------------

  Future<void> _onRefreshSchedule(
    RefreshSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.status == ScheduleStatus.refreshing ||
        state.status == ScheduleStatus.initialLoading) {
      event.completer?.complete();
      return;
    }

    emit(state.copyWith(status: ScheduleStatus.refreshing, clearError: true));

    try {
      await _fetchData(emit, page: 1, reset: true);
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  // ---------------------------------------------------------------------------
  // SELECT CALENDAR DAY
  // ---------------------------------------------------------------------------

  Future<void> _onSelectCalendarDay(
    SelectCalendarDay event,
    Emitter<ScheduleState> emit,
  ) async {
    final selectedDate = event.day.dateString;

    // If user taps the already selected date,
    // don't make another API request.
    if (state.selectedDateString == selectedDate) {
      return;
    }

    emit(
      state.copyWith(
        selectedDateString: selectedDate,
        selectedDayDate: event.day.date,
        status: ScheduleStatus.initialLoading,
        isAppointmentsLoading: true,
        clearError: true,
      ),
    );

    await _fetchData(
      emit,
      page: 1,
      reset: true,
      date: selectedDate,
      skipCalendarUpdate: true,
    );
  }

  // ---------------------------------------------------------------------------
  // LOAD NEXT PAGE
  // ---------------------------------------------------------------------------

  Future<void> _onLoadNextSchedulePage(
    LoadNextSchedulePage event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.isLoadingNextPage) {
      return;
    }

    if (state.hasReachedEnd) {
      return;
    }

    emit(state.copyWith(isLoadingNextPage: true, clearError: true));

    await _fetchData(
      emit,
      page: state.currentPage + 1,
      reset: false,
      date: state.selectedDateString,
      skipCalendarUpdate: true,
    );
  }

  // ---------------------------------------------------------------------------
  // JUMP TO TODAY
  // ---------------------------------------------------------------------------

  Future<void> _onJumpToToday(
    JumpToToday event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.status == ScheduleStatus.initialLoading) {
      return;
    }

    emit(
      state.copyWith(
        status: ScheduleStatus.initialLoading,
        isAppointmentsLoading: true,
        clearError: true,
      ),
    );

    await _fetchData(emit, page: 1, reset: true, date: null);
  }

  // ---------------------------------------------------------------------------
  // FETCH DATA
  // ---------------------------------------------------------------------------

  Future<void> _fetchData(
    Emitter<ScheduleState> emit, {
    required int page,
    required bool reset,
    String? date,
    bool skipCalendarUpdate = false,
  }) async {
    try {
      developer.log(
        'Fetching schedule: page=$page, limit=$_limit, date=$date',
        name: 'ScheduleBloc',
      );

      final response = await _getScheduleUseCase(
        page: page,
        limit: _limit,
        date: date,
      );

      // -----------------------------------------------------------------------
      // APPOINTMENTS
      // -----------------------------------------------------------------------

      final newAppointments = reset
          ? response.appointments.list
          : [...state.appointments, ...response.appointments.list];

      // De-duplicate appointments by ID.
      final seenIds = <String>{};

      final dedupedAppointments = newAppointments.where((appointment) {
        return seenIds.add(appointment.id);
      }).toList();

      // -----------------------------------------------------------------------
      // PAGINATION
      // -----------------------------------------------------------------------

      final totalPages = response.appointments.totalPages;

      final hasReachedEnd =
          totalPages == 0 || response.appointments.page >= totalPages;

      // -----------------------------------------------------------------------
      // SELECTED DATE
      // -----------------------------------------------------------------------

      String? selectedDateString = state.selectedDateString;

      int selectedDayDate = state.selectedDayDate;

      // When the first response arrives and there is no selected date,
      // determine the selected date from the response.
      if (reset && (selectedDateString == null || selectedDateString.isEmpty)) {
        if (response.appointments.list.isNotEmpty) {
          final firstTime = response.appointments.list.first.time;

          try {
            final parsedDate = DateTime.parse(firstTime);

            selectedDateString =
                '${parsedDate.year}-'
                '${parsedDate.month.toString().padLeft(2, '0')}-'
                '${parsedDate.day.toString().padLeft(2, '0')}';
          } catch (_) {
            if (response.calendar.isNotEmpty) {
              selectedDateString = response.calendar.first.dateString;
            }
          }
        } else if (response.calendar.isNotEmpty) {
          selectedDateString = response.calendar.first.dateString;
        }
      }

      // -----------------------------------------------------------------------
      // SELECTED CALENDAR DAY
      // -----------------------------------------------------------------------

      if (selectedDateString != null &&
          selectedDateString.isNotEmpty &&
          response.calendar.isNotEmpty) {
        final match = response.calendar.firstWhere(
          (day) => day.dateString == selectedDateString,
          orElse: () => CalendarDay(
            dayName: '',
            date: 0,
            count: 0,
            dateString: selectedDateString!,
          ),
        );

        selectedDayDate = match.date;
      }

      // -----------------------------------------------------------------------
      // CALENDAR UPDATE
      // -----------------------------------------------------------------------

      bool shouldUpdateCalendar = !skipCalendarUpdate;

      // If calendar is empty, we need to populate it.
      if (skipCalendarUpdate && state.calendar.isEmpty) {
        shouldUpdateCalendar = true;
      }

      // If API returned a different month, update calendar.
      if (!shouldUpdateCalendar &&
          response.calendar.isNotEmpty &&
          state.calendar.isNotEmpty) {
        try {
          final newMonth = DateTime.parse(response.calendar.first.dateString);

          final oldMonth = DateTime.parse(state.calendar.first.dateString);

          if (newMonth.year != oldMonth.year ||
              newMonth.month != oldMonth.month) {
            shouldUpdateCalendar = true;
          }
        } catch (_) {
          // Keep existing calendar if date parsing fails.
        }
      }

      // -----------------------------------------------------------------------
      // STATUS
      // -----------------------------------------------------------------------

      final finalStatus = dedupedAppointments.isEmpty
          ? ScheduleStatus.empty
          : ScheduleStatus.success;

      // -----------------------------------------------------------------------
      // EMIT SUCCESS
      // -----------------------------------------------------------------------

      emit(
        state.copyWith(
          status: finalStatus,
          calendar: shouldUpdateCalendar ? response.calendar : state.calendar,
          stats: response.summary,
          appointments: dedupedAppointments,
          selectedDateString: selectedDateString,
          selectedDayDate: selectedDayDate,
          currentPage: response.appointments.page,
          totalPages: response.appointments.totalPages,
          hasReachedEnd: hasReachedEnd,
          isLoadingNextPage: false,
          isAppointmentsLoading: false,
          clearError: true,
        ),
      );

      developer.log(
        'Schedule loaded successfully. '
        'appointments=${dedupedAppointments.length}, '
        'page=${response.appointments.page}, '
        'totalPages=${response.appointments.totalPages}',
        name: 'ScheduleBloc',
      );
    }
    // -------------------------------------------------------------------------
    // NETWORK EXCEPTION
    // -------------------------------------------------------------------------
    on NetworkException catch (e, stackTrace) {
      developer.log(
        'NetworkException while fetching schedule.',
        name: 'ScheduleBloc',
        error: e,
        stackTrace: stackTrace,
      );

      _emitFailure(emit, e.message, reset: reset);
    }
    // -------------------------------------------------------------------------
    // DIO EXCEPTION
    // -------------------------------------------------------------------------
    on DioException catch (e, stackTrace) {
      developer.log(
        'DioException while fetching schedule.',
        name: 'ScheduleBloc',
        error: e,
        stackTrace: stackTrace,
      );

      String message = 'Something went wrong. Please try again.';

      if (e.error is NetworkException) {
        message = (e.error as NetworkException).message;
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }

      _emitFailure(emit, message, reset: reset);
    }
    // -------------------------------------------------------------------------
    // UNKNOWN EXCEPTION
    // -------------------------------------------------------------------------
    catch (e, stackTrace) {
      developer.log(
        'Unexpected exception while fetching schedule.',
        name: 'ScheduleBloc',
        error: e,
        stackTrace: stackTrace,
      );

      _emitFailure(
        emit,
        'Something went wrong. Please try again.',
        reset: reset,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // FAILURE HANDLER
  // ---------------------------------------------------------------------------

  void _emitFailure(
    Emitter<ScheduleState> emit,
    String message, {
    required bool reset,
  }) {
    if (reset) {
      emit(
        state.copyWith(
          status: ScheduleStatus.failure,
          errorMessage: message,
          isLoadingNextPage: false,
          isAppointmentsLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoadingNextPage: false,
          isAppointmentsLoading: false,
          errorMessage: message,
        ),
      );
    }
  }
}
