import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/ui/dialog_helper.dart';
import 'package:medicompare/features/home/data/models/appointment.dart';
import 'package:medicompare/features/home/data/models/clinic_status.dart';

import 'package:medicompare/features/home/data/repositories/home_repository.dart';
import 'package:medicompare/features/home/domain/usecases/get_dashboard_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetDashboardUseCase _getDashboardUseCase;

  static const int _pageLimit = 10;

  HomeBloc({GetDashboardUseCase? getDashboardUseCase})
    : _getDashboardUseCase =
          getDashboardUseCase ?? GetDashboardUseCase(HomeRepositoryImpl()),
      super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
    on<HomeSearchChanged>(_onSearchChanged);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeBottomNavChanged>(_onBottomNavChanged);
    on<HomeNextPageRequested>(_onNextPageRequested);
  }

  // -------------------------------------------------------------------------
  // INITIAL LOAD
  // -------------------------------------------------------------------------

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    DialogHelper.isAtLoginScreen = false;

    emit(
      state.copyWith(
        status: HomeStatus.loading,
        clearError: true,
        isLoadingNextPage: false,
      ),
    );

    await _loadPage(emit, page: 1, reset: true);
  }

  // -------------------------------------------------------------------------
  // PULL TO REFRESH
  // -------------------------------------------------------------------------

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    // Prevent duplicate refresh/API calls.
    if (state.status == HomeStatus.loading) {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
      return;
    }

    emit(state.copyWith(clearError: true));

    try {
      await _loadPage(emit, page: 1, reset: true);
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  // -------------------------------------------------------------------------
  // LOAD NEXT PAGE
  // -------------------------------------------------------------------------

  Future<void> _onNextPageRequested(
    HomeNextPageRequested event,
    Emitter<HomeState> emit,
  ) async {
    // Prevent duplicate pagination calls.
    if (state.isLoadingNextPage) {
      return;
    }

    // No more pages.
    if (state.hasReachedEnd) {
      return;
    }

    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingNextPage: true, clearError: true));

    await _loadPage(emit, page: nextPage, reset: false);
  }

  // -------------------------------------------------------------------------
  // CORE API FETCH
  // -------------------------------------------------------------------------

  Future<void> _loadPage(
    Emitter<HomeState> emit, {
    required int page,
    required bool reset,
  }) async {
    try {
      final response = await _getDashboardUseCase(
        page: page,
        limit: _pageLimit,
      );

      final incoming = response.todayAppointments;

      // -----------------------------------------------------------------------
      // APPOINTMENTS
      // -----------------------------------------------------------------------

      final newList = reset
          ? incoming.list
          : [...state.appointments, ...incoming.list];

      // -----------------------------------------------------------------------
      // REMOVE DUPLICATES
      // -----------------------------------------------------------------------

      final seenIds = <String>{};

      final deduplicated = newList.where((appointment) {
        return seenIds.add(appointment.id);
      }).toList();

      // -----------------------------------------------------------------------
      // PAGINATION
      // -----------------------------------------------------------------------

      final hasReachedEnd =
          incoming.totalPages == 0 || incoming.page >= incoming.totalPages;

      // -----------------------------------------------------------------------
      // SUCCESS
      // -----------------------------------------------------------------------

      emit(
        state.copyWith(
          status: HomeStatus.success,

          // Update dashboard counts only when loading page 1.
          stats: reset ? response.counts : state.stats,

          appointments: deduplicated,

          currentPage: incoming.page,

          totalPages: incoming.totalPages,

          hasReachedEnd: hasReachedEnd,

          isLoadingNextPage: false,

          clearError: true,
        ),
      );
    }
    // -------------------------------------------------------------------------
    // NETWORK EXCEPTION
    // -------------------------------------------------------------------------
    on NetworkException catch (e) {
      // AppHttpClient has already converted the original
      // network/API exception into a friendly message.

      _emitFailure(emit, e.message, reset: reset);
    }
    // -------------------------------------------------------------------------
    // UNKNOWN EXCEPTION
    // -------------------------------------------------------------------------
    catch (e) {
      _emitFailure(
        emit,
        'Something went wrong. Please try again.',
        reset: reset,
      );
    }
  }

  // -------------------------------------------------------------------------
  // FAILURE HANDLER
  // -------------------------------------------------------------------------

  void _emitFailure(
    Emitter<HomeState> emit,
    String message, {
    required bool reset,
  }) {
    if (reset) {
      // Initial load / refresh failure.
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: message,
          isLoadingNextPage: false,
        ),
      );
    } else {
      // Pagination failure.
      //
      // Keep the existing appointments on screen.
      // Only stop the bottom pagination loader and show the error.
      emit(state.copyWith(isLoadingNextPage: false, errorMessage: message));
    }
  }

  // -------------------------------------------------------------------------
  // SEARCH
  // -------------------------------------------------------------------------

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  // -------------------------------------------------------------------------
  // TAB
  // -------------------------------------------------------------------------

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  // -------------------------------------------------------------------------
  // BOTTOM NAVIGATION
  // -------------------------------------------------------------------------

  void _onBottomNavChanged(
    HomeBottomNavChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(bottomNavIndex: event.index));
  }
}
