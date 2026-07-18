import 'package:flutter/material.dart';

import 'custom_time_picker.dart';

class BreakTimeCard extends StatelessWidget {
  final TimeOfDay startBreak;
  final TimeOfDay endBreak;

  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final VoidCallback? onAddBreak;

  const BreakTimeCard({
    super.key,
    required this.startBreak,
    required this.endBreak,
    required this.onStartTap,
    required this.onEndTap,
    this.onAddBreak,
  });

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
        children: [
          Row(
            children: [
              const Text(
                "Break Time",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: onAddBreak,
                child: const Text(
                  "+ Add Break",
                  style: TextStyle(
                    color: Color(0xff6D28D9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              CustomTimePicker(
                title: "Start Break",
                time: startBreak,
                onTap: onStartTap,
              ),

              const SizedBox(width: 16),

              CustomTimePicker(
                title: "End Break",
                time: endBreak,
                onTap: onEndTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
