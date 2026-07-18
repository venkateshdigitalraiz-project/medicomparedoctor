import 'package:flutter/material.dart';

class SlotDurationSelector extends StatelessWidget {
  final int selectedDuration;
  final ValueChanged<int> onSelected;

  const SlotDurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onSelected,
  });

  static const List<int> durations = [15, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Slot Duration",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),

        const SizedBox(height: 18),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: durations.map((minutes) {
            final selected = minutes == selectedDuration;

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onSelected(minutes),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 70,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xff6D28D9) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? const Color(0xff601CA3)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  "$minutes min",
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
