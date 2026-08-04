part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  /// Whether the month-grid popup is currently visible.
  /// Default is false -> grid is NOT shown until the edit icon is tapped.
  final bool isPopupVisible;

  final DateTime focusedMonth; // which month/year the popup grid displays
  final DateTime selectedDate; // currently selected day (blue circle)

  /// Dates that should render with the red "busy" circle.
  final List<DateTime> busyDates;

  /// Dates that should render with the lavender "highlight" circle.
  final List<DateTime> highlightedDates;

  const CalendarState({
    required this.isPopupVisible,
    required this.focusedMonth,
    required this.selectedDate,
    required this.busyDates,
    required this.highlightedDates,
  });

  factory CalendarState.initial() {
    final now = DateTime(2026, 7, 4);
    return CalendarState(
      isPopupVisible: false,
      focusedMonth: DateTime(2026, 7),
      selectedDate: now,
      busyDates: [
        DateTime(2026, 7, 5),
        DateTime(2026, 7, 11),
        DateTime(2026, 7, 19),
        DateTime(2026, 7, 26),
      ],
      highlightedDates: [
        DateTime(2026, 7, 17),
        DateTime(2026, 7, 29),
      ],
    );
  }

  CalendarState copyWith({
    bool? isPopupVisible,
    DateTime? focusedMonth,
    DateTime? selectedDate,
    List<DateTime>? busyDates,
    List<DateTime>? highlightedDates,
  }) {
    return CalendarState(
      isPopupVisible: isPopupVisible ?? this.isPopupVisible,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      busyDates: busyDates ?? this.busyDates,
      highlightedDates: highlightedDates ?? this.highlightedDates,
    );
  }

  @override
  List<Object?> get props => [
        isPopupVisible,
        focusedMonth,
        selectedDate,
        busyDates,
        highlightedDates,
      ];
}
