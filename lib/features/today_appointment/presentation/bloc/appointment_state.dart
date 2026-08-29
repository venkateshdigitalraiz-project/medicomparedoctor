import 'package:equatable/equatable.dart';
import 'package:medicompare/features/today_appointment/domain/entities/today_appointment_entity.dart';

enum AppointmentStatusFlag { initial, loading, success, failure }

class AppointmentState extends Equatable {
  final AppointmentStatusFlag status;
  final List<TodayAppointmentEntity> allAppointments;
  final List<TodayAppointmentEntity> visibleAppointments;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedStatus;
  final String? selectedDate;
  final int currentPage;
  final int totalPages;
  final int total;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  const AppointmentState({
    this.status = AppointmentStatusFlag.initial,
    this.allAppointments = const [],
    this.visibleAppointments = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.selectedStatus,
    this.selectedDate,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });

  AppointmentState copyWith({
    AppointmentStatusFlag? status,
    List<TodayAppointmentEntity>? allAppointments,
    List<TodayAppointmentEntity>? visibleAppointments,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
    String? selectedStatus,
    String? selectedDate,
    int? currentPage,
    int? totalPages,
    int? total,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      allAppointments: allAppointments ?? this.allAppointments,
      visibleAppointments: visibleAppointments ?? this.visibleAppointments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedDate: selectedDate ?? this.selectedDate,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allAppointments,
        visibleAppointments,
        errorMessage,
        searchQuery,
        selectedStatus,
        selectedDate,
        currentPage,
        totalPages,
        total,
        isLoadingMore,
        hasReachedEnd,
      ];
}
