import 'package:equatable/equatable.dart';
import 'package:medicompare/features/calendar/data/models/timeline_event.dart';

class CalendarState extends Equatable {
  final int year;
  final int month; // 1-12
  final int selectedDay;
  final List<DateMarker> markers;
  final String availabilityStart;
  final String availabilityEnd;
  final List<TimelineEvent> timeline;
  final bool isLoading;

  const CalendarState({
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.markers,
    required this.availabilityStart,
    required this.availabilityEnd,
    required this.timeline,
    this.isLoading = false,
  });

  factory CalendarState.initial() => const CalendarState(
        year: 2026,
        month: 7,
        selectedDay: 4,
        markers: [],
        availabilityStart: '09:00 AM',
        availabilityEnd: '06:00 PM',
        timeline: [],
        isLoading: true,
      );

  DateMarkerType markerFor(int day) {
    final match = markers.where((m) => m.day == day);
    if (match.isEmpty) return DateMarkerType.none;
    return match.first.type;
  }

  CalendarState copyWith({
    int? year,
    int? month,
    int? selectedDay,
    List<DateMarker>? markers,
    String? availabilityStart,
    String? availabilityEnd,
    List<TimelineEvent>? timeline,
    bool? isLoading,
  }) {
    return CalendarState(
      year: year ?? this.year,
      month: month ?? this.month,
      selectedDay: selectedDay ?? this.selectedDay,
      markers: markers ?? this.markers,
      availabilityStart: availabilityStart ?? this.availabilityStart,
      availabilityEnd: availabilityEnd ?? this.availabilityEnd,
      timeline: timeline ?? this.timeline,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        year,
        month,
        selectedDay,
        markers,
        availabilityStart,
        availabilityEnd,
        timeline,
        isLoading,
      ];
}
