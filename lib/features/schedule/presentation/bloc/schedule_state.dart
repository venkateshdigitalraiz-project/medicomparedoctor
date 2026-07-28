import 'package:equatable/equatable.dart';
import '../../data/models/appointment.dart';

enum ScheduleStatus {
  initial,
  initialLoading,
  refreshing,
  success,
  empty,
  failure
}

class ScheduleState extends Equatable {
  final ScheduleStatus status;
  final String? selectedDateString; // The actual string from CalendarDay.dateString
  final int selectedDayDate; // e.g. 1, 2, 3...
  final List<CalendarDay> calendar;
  final ScheduleStats stats;
  final List<Appointment> appointments;
  final String? errorMessage;

  // Pagination
  final int currentPage;
  final int totalPages;
  final bool isLoadingNextPage;
  final bool hasReachedEnd;

  // Day list tapping specific loading
  final bool isAppointmentsLoading;

  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.selectedDateString,
    this.selectedDayDate = 0,
    this.calendar = const [],
    this.stats = const ScheduleStats(total: 0, confirmed: 0, waiting: 0, cancelled: 0),
    this.appointments = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 0,
    this.isLoadingNextPage = false,
    this.hasReachedEnd = false,
    this.isAppointmentsLoading = false,
  });

  factory ScheduleState.initial() => const ScheduleState();

  ScheduleState copyWith({
    ScheduleStatus? status,
    String? selectedDateString,
    int? selectedDayDate,
    List<CalendarDay>? calendar,
    ScheduleStats? stats,
    List<Appointment>? appointments,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    bool? isLoadingNextPage,
    bool? hasReachedEnd,
    bool? isAppointmentsLoading,
    bool clearError = false,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      selectedDateString: selectedDateString ?? this.selectedDateString,
      selectedDayDate: selectedDayDate ?? this.selectedDayDate,
      calendar: calendar ?? this.calendar,
      stats: stats ?? this.stats,
      appointments: appointments ?? this.appointments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isAppointmentsLoading: isAppointmentsLoading ?? this.isAppointmentsLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedDateString,
        selectedDayDate,
        calendar,
        stats,
        appointments,
        errorMessage,
        currentPage,
        totalPages,
        isLoadingNextPage,
        hasReachedEnd,
        isAppointmentsLoading,
      ];
}
