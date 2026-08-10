import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTimePicker extends StatelessWidget {
  final String title;
  final TimeOfDay time;
  final VoidCallback onTap;

  const CustomTimePicker({
    super.key,
    required this.title,
    required this.time,
    required this.onTap,
  });

  String _formatTime(BuildContext context) {
    final now = DateTime.now();

    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            fontFamily: "Poppins",
          ),
        ),

        const SizedBox(height: 10),

        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatTime(context),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1F2937),
                    ),
                  ),
                ),

                const Icon(
                  Icons.access_time_outlined,
                  color: Color(0xffD1D5DB),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
