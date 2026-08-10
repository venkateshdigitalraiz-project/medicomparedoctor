import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicompare/features/holidays/data/models/holiday_model.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime visibleMonth;
  final DateTime selectedDate;
  final List<Holiday> holidays;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CalendarWidget({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.holidays,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSelectDate,
    required this.onEdit,
    required this.onDelete,
  });

  static const _purple = Color(0xFF6A1B9A);
  static const _red = Color(0xFFE53935);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth =
        DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final today = DateTime(2026, 8, 15);

    final List<Widget> dayCells = [];

    // Leading days from previous month (greyed out)
    final prevMonthLastDay =
        DateTime(visibleMonth.year, visibleMonth.month, 0).day;
    for (int i = 0; i < startWeekday; i++) {
      final dayNum = prevMonthLastDay - startWeekday + i + 1;
      dayCells.add(_dayCell(dayNum.toString(), isMuted: true));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(visibleMonth.year, visibleMonth.month, day);
      final holidayMatch = holidays.where((h) => _isSameDay(h.date, date));
      final isHoliday = holidayMatch.isNotEmpty &&
          holidayMatch.first.type != HolidayType.blocked;
      final isBlocked = holidayMatch.isNotEmpty &&
          holidayMatch.first.type == HolidayType.blocked;
      final isSelected = _isSameDay(date, selectedDate);
      final isToday = _isSameDay(date, today);

      dayCells.add(
        _dayCell(
          day.toString(),
          isSelected: isSelected,
          isToday: isToday && !isSelected,
          isBlocked: isBlocked,
          isHoliday: isHoliday,
          onTap: () => onSelectDate(date),
        ),
      );
    }

    // Trailing days
    int trailing = 1;
    while (dayCells.length % 7 != 0) {
      dayCells.add(_dayCell(trailing.toString(), isMuted: true));
      trailing++;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('MMMM yyyy').format(visibleMonth),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _navButton(Icons.chevron_left, onPrevMonth),
              const SizedBox(width: 6),
              _navButton(Icons.chevron_right, onNextMonth),
              const SizedBox(width: 10),
              _squareIconButton(
                icon: Icons.edit,
                color: Colors.white,
                bgColor: _purple,
                onTap: onEdit,
              ),
              const SizedBox(width: 8),
              _squareIconButton(
                icon: Icons.delete,
                color: Colors.white,
                bgColor: _red,
                onTap: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _legend(_purple, 'Holiday'),
              const SizedBox(width: 16),
              _legend(_red, 'Blocked'),
              const SizedBox(width: 16),
              _legend(const Color(0xFFBDBDBD), 'Today'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: dayCells,
          ),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }

  Widget _squareIconButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _dayCell(
    String label, {
    bool isMuted = false,
    bool isSelected = false,
    bool isToday = false,
    bool isHoliday = false,
    bool isBlocked = false,
    VoidCallback? onTap,
  }) {
    Color? bgColor;
    Color textColor = Colors.black87;

    if (isSelected) {
      bgColor = _purple;
      textColor = Colors.white;
    } else if (isBlocked) {
      bgColor = const Color(0xFFFFEBEE);
      textColor = _red;
    } else if (isToday) {
      bgColor = const Color(0xFFF0F0F0);
    } else if (isMuted) {
      textColor = Colors.black26;
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: textColor,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isHoliday && !isSelected)
                Positioned(
                  bottom: 2,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: _purple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
