import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/features/today_appointment/domain/entities/today_appointment_entity.dart';
import 'package:medicompare/features/today_appointment/domain/usecases/get_today_appointments_usecase.dart';
import 'package:medicompare/features/today_appointment/data/repositories/today_appointment_repository_impl.dart';
import 'package:medicompare/features/today_appointment/presentation/bloc/appointment_event.dart';
import 'package:medicompare/features/today_appointment/presentation/bloc/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetTodayAppointmentsUseCase _getTodayAppointmentsUseCase;
  static const int _limit = 10;

  AppointmentBloc({GetTodayAppointmentsUseCase? getTodayAppointmentsUseCase})
      : _getTodayAppointmentsUseCase = getTodayAppointmentsUseCase ??
            GetTodayAppointmentsUseCase(TodayAppointmentRepositoryImpl()),
        super(const AppointmentState()) {
    on<LoadTodayAppointments>(_onLoadAppointments);
    on<LoadMoreTodayAppointments>(_onLoadMoreAppointments);
    on<SearchTodayAppointments>(_onSearchAppointments);
    on<FilterTodayAppointmentsByStatus>(_onFilterByStatus);
    on<FilterByDate>(_onFilterByDate);
  }

  Future<void> _onLoadAppointments(
    LoadTodayAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    if (event.completer == null) {
      emit(state.copyWith(
        status: AppointmentStatusFlag.loading,
        clearError: true,
        isLoadingMore: false,
      ));
    }

    try {
      final response = await _getTodayAppointmentsUseCase(
        page: 1,
        limit: _limit,
      );

      final appointments = response.list;
      final hasReachedEnd =
          response.totalPages <= 1 || response.list.length >= response.total;

      final filtered = _applyFilter(
        appointments,
        state.searchQuery,
        state.selectedStatus,
      );

      emit(
        state.copyWith(
          status: AppointmentStatusFlag.success,
          allAppointments: appointments,
          visibleAppointments: filtered,
          currentPage: 1,
          totalPages: response.totalPages,
          total: response.total,
          hasReachedEnd: hasReachedEnd,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } on NetworkException catch (e) {
      emit(
        state.copyWith(
          status: AppointmentStatusFlag.failure,
          errorMessage: e.message,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AppointmentStatusFlag.failure,
          errorMessage: 'Failed to load appointments: $e',
          isLoadingMore: false,
        ),
      );
    } finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  Future<void> _onLoadMoreAppointments(
    LoadMoreTodayAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedEnd) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    try {
      final response = await _getTodayAppointmentsUseCase(
        page: nextPage,
        limit: _limit,
      );

      final combined = [...state.allAppointments, ...response.list];
      final seenIds = <String>{};
      final deduplicated = combined.where((a) => seenIds.add(a.id)).toList();

      final hasReachedEnd =
          response.page >= response.totalPages || deduplicated.length >= response.total || response.list.isEmpty;

      final filtered = _applyFilter(
        deduplicated,
        state.searchQuery,
        state.selectedStatus,
      );

      emit(
        state.copyWith(
          allAppointments: deduplicated,
          visibleAppointments: filtered,
          currentPage: nextPage,
          totalPages: response.totalPages,
          total: response.total,
          hasReachedEnd: hasReachedEnd,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void _onSearchAppointments(
    SearchTodayAppointments event,
    Emitter<AppointmentState> emit,
  ) {
    final query = event.query;
    final filtered = _applyFilter(
      state.allAppointments,
      query,
      state.selectedStatus,
    );

    emit(
      state.copyWith(
        searchQuery: query,
        visibleAppointments: filtered,
      ),
    );
  }

  void _onFilterByStatus(
    FilterTodayAppointmentsByStatus event,
    Emitter<AppointmentState> emit,
  ) {
    final status = event.status;
    final filtered = _applyFilter(
      state.allAppointments,
      state.searchQuery,
      status,
    );

    emit(
      state.copyWith(
        selectedStatus: status,
        visibleAppointments: filtered,
      ),
    );
  }

  void _onFilterByDate(FilterByDate event, Emitter<AppointmentState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  List<TodayAppointmentEntity> _applyFilter(
    List<TodayAppointmentEntity> source,
    String query,
    String? status,
  ) {
    final q = query.trim().toLowerCase();
    return source.where((item) {
      final matchesQuery = q.isEmpty ||
          item.displayName.toLowerCase().contains(q) ||
          item.phone.toLowerCase().contains(q) ||
          item.patientId.toLowerCase().contains(q) ||
          item.email.toLowerCase().contains(q) ||
          item.city.toLowerCase().contains(q);

      final matchesStatus = status == null ||
          status.isEmpty ||
          status.toLowerCase() == 'all' ||
          item.status.toLowerCase() == status.toLowerCase();

      return matchesQuery && matchesStatus;
    }).toList();
  }
}
