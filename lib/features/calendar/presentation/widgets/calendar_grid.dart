import 'package:flutter/material.dart';
import 'package:medicompare/features/calendar/data/models/timeline_event.dart';

class CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final int selectedDay;
  final DateMarkerType Function(int day) markerFor;
  final ValueChanged<int> onDaySelected;

  const CalendarGrid({
    super.key,
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.markerFor,
    required this.onDaySelected,
  });

  int get _daysInMonth => DateTime(year, month + 1, 0).day;

  // Flutter's DateTime.weekday: Mon=1 ... Sun=7.
  // The design's grid starts the week on Sunday, so convert to 0=Sun..6=Sat.
  int get _firstWeekdayOffset => DateTime(year, month, 1).weekday % 7;

  @override
  Widget build(BuildContext context) {
    final totalCells = _firstWeekdayOffset + _daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    const weekdayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekdayLabels
              .map((label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        for (int row = 0; row < rowCount; row++) ...[
          Row(
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final day = cellIndex - _firstWeekdayOffset + 1;
              final isValidDay = day >= 1 && day <= _daysInMonth;

              return Expanded(
                child: isValidDay
                    ? _DayCell(
                        day: day,
                        isSelected: day == selectedDay,
                        markerType: markerFor(day),
                        onTap: () => onDaySelected(day),
                      )
                    : const SizedBox(height: 48),
              );
            }),
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final DateMarkerType markerType;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.markerType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color textColor = const Color(0xFF1F2937);
    FontWeight fontWeight = FontWeight.w500;

    if (isSelected) {
      backgroundColor = const Color(0xFF2563EB); // blue
      textColor = Colors.white;
      fontWeight = FontWeight.w700;
    } else if (markerType == DateMarkerType.busy) {
      backgroundColor = const Color(0xFFEF4444); // red
      textColor = Colors.white;
      fontWeight = FontWeight.w700;
    } else if (markerType == DateMarkerType.holiday) {
      backgroundColor = const Color(0xFFE9D5FF); // light purple
      textColor = const Color(0xFF7C3AED);
      fontWeight = FontWeight.w700;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
