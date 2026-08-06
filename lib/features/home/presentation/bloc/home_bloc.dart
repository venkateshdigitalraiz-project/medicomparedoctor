import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/appointment.dart';
import '../../data/models/clinic_status.dart';
import '../../data/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  static const int _pageLimit = 10;

  HomeBloc({HomeRepository? repository})
      : _repository = repository ?? HomeRepositoryImpl(),
        super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
    on<HomeSearchChanged>(_onSearchChanged);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeBottomNavChanged>(_onBottomNavChanged);
    on<HomeNextPageRequested>(_onNextPageRequested);
  }

  // -------------------------------------------------------------------------
  // Event handlers
  // -------------------------------------------------------------------------

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await _loadPage(emit, page: 1, reset: true);
  }

  Future<void> _onRefreshed(
      HomeRefreshed event, Emitter<HomeState> emit) async {
    try {
      await _loadPage(emit, page: 1, reset: true);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onNextPageRequested(
      HomeNextPageRequested event, Emitter<HomeState> emit) async {
    // Guard: do not fetch if already loading, or no more pages exist.
    if (state.isLoadingNextPage) return;
    if (state.hasReachedEnd) return;

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingNextPage: true));
    await _loadPage(emit, page: nextPage, reset: false);
  }

  // -------------------------------------------------------------------------
  // Core fetch
  // -------------------------------------------------------------------------

  Future<void> _loadPage(
    Emitter<HomeState> emit, {
    required int page,
    required bool reset,
  }) async {
    try {
      final response = await _repository.fetchDashboard(
        page: page,
        limit: _pageLimit,
      );

      final incoming = response.todayAppointments;
      final newList = reset
          ? incoming.list
          : [...state.appointments, ...incoming.list];

      // De-duplicate by id in case the API returns overlapping items.
      final seen = <String>{};
      final deduplicated = newList.where((a) => seen.add(a.id)).toList();

      final hasReachedEnd = incoming.totalPages == 0 ||
          incoming.page >= incoming.totalPages;

      emit(state.copyWith(
        status: HomeStatus.success,
        stats: reset ? response.counts : state.stats,
        appointments: deduplicated,
        currentPage: incoming.page,
        totalPages: incoming.totalPages,
        hasReachedEnd: hasReachedEnd,
        isLoadingNextPage: false,
        clearError: true,
      ));
    } catch (e) {
      if (reset) {
        emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: e.toString(),
          isLoadingNextPage: false,
        ));
      } else {
        // Pagination error — don't wipe the screen; just stop the spinner.
        emit(state.copyWith(
          isLoadingNextPage: false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  // -------------------------------------------------------------------------
  // UI-only events (no API calls)
  // -------------------------------------------------------------------------

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onBottomNavChanged(
      HomeBottomNavChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(bottomNavIndex: event.index));
  }
}
