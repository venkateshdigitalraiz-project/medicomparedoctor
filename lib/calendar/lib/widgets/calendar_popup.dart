import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/calendar_bloc.dart';

/// The month-grid calendar. Rendered INLINE inside the scrollable body
/// (see CalendarScreen) right below the header card.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _containsDay(List<DateTime> list, DateTime day) =>
      list.any((d) => _isSameDay(d, day));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        final month = state.focusedMonth;
        final firstDayOfMonth = DateTime(month.year, month.month, 1);
        final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

        // Sunday = 0 in grid
        final leadingBlanks = firstDayOfMonth.weekday % 7;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () =>
                        context.read<CalendarBloc>().add(const ChangeMonth(-1)),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        DateFormat('MMMM yyyy').format(month),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () =>
                        context.read<CalendarBloc>().add(const ChangeMonth(1)),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              /// Week names
              Row(
                children: const [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Sun",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Mon",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Tue",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Wed",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Thu",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Fri",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Sat",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: leadingBlanks + daysInMonth,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  if (index < leadingBlanks) {
                    return const SizedBox.shrink();
                  }

                  final day = index - leadingBlanks + 1;
                  final date = DateTime(month.year, month.month, day);

                  final isSelected = _isSameDay(date, state.selectedDate);
                  final isBusy = _containsDay(state.busyDates, date);
                  final isHighlighted = _containsDay(
                    state.highlightedDates,
                    date,
                  );

                  Color? bg;

                  // Sunday text is red by default
                  Color textColor = date.weekday == DateTime.sunday
                      ? Colors.red
                      : Colors.black87;

                  if (isSelected) {
                    bg = const Color(0xFF2563EB);
                    textColor = Colors.white;
                  } else if (isBusy) {
                    bg = const Color(0xFFEF4444);
                    textColor = Colors.white;
                  } else if (isHighlighted) {
                    bg = const Color(0xFFD8CCF0);
                    // Keep Sunday red when highlighted
                    textColor = date.weekday == DateTime.sunday
                        ? Colors.red
                        : Colors.black87;
                  }

                  return GestureDetector(
                    onTap: () {
                      context.read<CalendarBloc>().add(SelectDate(date));
                    },
                    child: Center(
                      child: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
