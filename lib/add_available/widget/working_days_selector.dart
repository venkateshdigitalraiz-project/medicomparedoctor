import 'package:flutter/material.dart';

class WorkingDaysSelector extends StatelessWidget {
  final List<String> selectedDays;
  final ValueChanged<String> onDayTap;

  const WorkingDaysSelector({
    super.key,
    required this.selectedDays,
    required this.onDayTap,
  });

  static const List<String> days = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Working Days",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 18),

          // Wrap(
          //   spacing: 10,
          //   runSpacing: 10,
          //   children: days.map((day) {
          //     final selected = selectedDays.contains(day);

          //     return InkWell(
          //       borderRadius: BorderRadius.circular(12),
          //       onTap: () => onDayTap(day),
          //       child: AnimatedContainer(
          //         duration: const Duration(milliseconds: 250),
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 18,
          //           vertical: 12,
          //         ),
          //         decoration: BoxDecoration(
          //           color: selected ? const Color(0xff601CA3) : Colors.white,
          //           borderRadius: BorderRadius.circular(12),
          //           border: Border.all(
          //             color: selected
          //                 ? const Color(0xff601CA3)
          //                 : Colors.grey.shade300,
          //           ),
          //         ),
          //         child: Text(
          //           day,
          //           style: TextStyle(
          //             fontSize: 12,
          //             fontWeight: FontWeight.w500,
          //             color: selected ? Colors.white : Colors.black87,
          //           ),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: days.map((day) {
                final selected = selectedDays.contains(day);

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onDayTap(day),
                    child: SizedBox(
                      width: 40, // Same width for every box
                      height: 40, // Same height for every box
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xff601CA3)
                              : Color(0xFFB3B3B3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? const Color(0xff601CA3)
                                : Colors.grey.shade300,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
