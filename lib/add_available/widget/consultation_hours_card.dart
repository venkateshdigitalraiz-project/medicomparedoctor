import 'package:flutter/material.dart';

import 'custom_time_picker.dart';

class ConsultationHoursCard extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  const ConsultationHoursCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartTap,
    required this.onEndTap,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Consultation Hours",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              CustomTimePicker(
                title: "Start Time",
                time: startTime,
                onTap: onStartTap,
              ),

              const SizedBox(width: 16),

              CustomTimePicker(
                title: "End Time",
                time: endTime,
                onTap: onEndTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
