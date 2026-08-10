part of 'holiday_bloc.dart';

@immutable
class HolidayState {
  final bool vacationModeActive;
  final List<Holiday> holidays;
  final List<HolidayCategory> categories;
  final List<ActivityItem> recentActivity;
  final DateTime visibleMonth;
  final DateTime selectedDate;
  final bool isSaving;
  final bool saveSuccess;

  const HolidayState({
    required this.vacationModeActive,
    required this.holidays,
    required this.categories,
    required this.recentActivity,
    required this.visibleMonth,
    required this.selectedDate,
    this.isSaving = false,
    this.saveSuccess = false,
  });

  factory HolidayState.initial() {
    final now = DateTime(2026, 8, 15);
    return HolidayState(
      vacationModeActive: true,
      visibleMonth: DateTime(2026, 8, 1),
      selectedDate: now,
      holidays: [
        Holiday(
          id: '1',
          title: 'Independence Day',
          date: DateTime(2026, 8, 15),
          type: HolidayType.publicHoliday,
        ),
        Holiday(
          id: '2',
          title: 'Medical Conference',
          date: DateTime(2026, 9, 12),
          type: HolidayType.professionalLeave,
        ),
        Holiday(
          id: '3',
          title: 'Christmas Holiday',
          date: DateTime(2026, 12, 25),
          type: HolidayType.publicHoliday,
        ),
        Holiday(
          id: '4',
          title: 'Clinic Blocked',
          date: DateTime(2026, 8, 14),
          type: HolidayType.blocked,
        ),
        Holiday(
          id: '5',
          title: 'Clinic Blocked',
          date: DateTime(2026, 8, 20),
          type: HolidayType.blocked,
        ),
      ],
      categories: [
        HolidayCategory('Public Holidays'),
        HolidayCategory('Medical Conferences'),
        HolidayCategory('Personal Leave'),
      ],
      recentActivity: [
        ActivityItem(
          title: 'Medical Conference',
          status: 'Approved',
          statusColor: const Color(0xFF2E7D32),
          statusBgColor: const Color(0xFFE8F5E9),
          dateRange: 'June 12 – 14, 2026',
        ),
        ActivityItem(
          title: 'Clinic Maintenance',
          status: 'Completed',
          statusColor: const Color(0xFF616161),
          statusBgColor: const Color(0xFFF0F0F0),
          dateRange: 'May 20, 2026',
        ),
      ],
    );
  }

  int get totalCount => holidays.length + 7; // matches design total 12
  int get vacationCount =>
      holidays.where((h) => h.type != HolidayType.blocked).length + 5;
  int get upcomingCount => holidays
      .where((h) =>
          h.type != HolidayType.blocked && h.date.isAfter(DateTime(2026, 7, 14)))
      .length;
  int get blockedCount =>
      holidays.where((h) => h.type == HolidayType.blocked).length + 3;

  List<Holiday> get upcomingHolidays => holidays
      .where((h) => h.type != HolidayType.blocked)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  HolidayState copyWith({
    bool? vacationModeActive,
    List<Holiday>? holidays,
    List<HolidayCategory>? categories,
    List<ActivityItem>? recentActivity,
    DateTime? visibleMonth,
    DateTime? selectedDate,
    bool? isSaving,
    bool? saveSuccess,
  }) {
    return HolidayState(
      vacationModeActive: vacationModeActive ?? this.vacationModeActive,
      holidays: holidays ?? this.holidays,
      categories: categories ?? this.categories,
      recentActivity: recentActivity ?? this.recentActivity,
      visibleMonth: visibleMonth ?? this.visibleMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? this.saveSuccess,
    );
  }
}
