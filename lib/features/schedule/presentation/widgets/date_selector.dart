import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicompare/common/common_add/appcolor.dart';
import 'package:medicompare/features/schedule/data/models/appointment.dart';

class DateSelector extends StatelessWidget {
  final String? selectedDateString;
  final List<CalendarDay> week;
  final ValueChanged<CalendarDay> onDateSelected;
  final VoidCallback onTodayTap;

  const DateSelector({
    super.key,
    required this.selectedDateString,
    required this.week,
    required this.onDateSelected,
    required this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine title text based on first calendar day's date or selectedDateString
    String titleText = '';
    if (selectedDateString != null && selectedDateString!.isNotEmpty) {
      try {
        final parsed = DateTime.parse(selectedDateString!);
        titleText = DateFormat('MMMM yyyy').format(parsed);
      } catch (_) {
        titleText = DateFormat('MMMM yyyy').format(DateTime.now());
      }
    } else {
      titleText = DateFormat('MMMM yyyy').format(DateTime.now());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    titleText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textDark,
                  ),
                ],
              ),
              GestureDetector(
                onTap: onTodayTap,
                child: const Text(
                  'Today',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins",
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 80,
          child: ListView.separated(
            key: const PageStorageKey('schedule_calendar_list'),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: week.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final day = week[index];
              final isSelected = day.dateString == selectedDateString;
              return GestureDetector(
                onTap: () => onDateSelected(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 54,
                  height: 65,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.purple : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.purple
                          : AppColors.chipBorder,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.purple.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            day.dayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            day.date.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      if (day.count > 0)
                        Positioned(
                          top: 0,
                          right: 2,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.white : AppColors.purple,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
