import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailabilityPreview extends StatelessWidget {
  final List<TimeOfDay> slots;

  const AvailabilityPreview({super.key, required this.slots});

  String _format(TimeOfDay time) {
    final now = DateTime.now();

    return DateFormat(
      'hh:mm a',
    ).format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 16),
          child: const Text(
            "Availability Preview",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              fontFamily: "Poppins",
            ),
          ),
        ),

        const SizedBox(height: 18),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots
              .map(
                (slot) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff6D28D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _format(slot),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
