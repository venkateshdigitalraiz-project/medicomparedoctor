import 'package:flutter/material.dart';

class AvailabilitySwitchCard extends StatelessWidget {
  final bool isAvailable;
  final String timing;
  final ValueChanged<bool> onChanged;

  const AvailabilitySwitchCard({
    super.key,
    required this.isAvailable,
    required this.timing,
    required this.onChanged,
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
      child: Row(
        children: [
          Container(
            height: 52,
            width: 8,
            decoration: BoxDecoration(
              color: const Color(0xff601CA3),
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Available Today",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  timing,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: isAvailable,
            //  activeColor: const Color(0xff601CA3),
            onChanged: onChanged,
            activeThumbColor: Colors.white, // Thumb color
            activeTrackColor: const Color(0xFF601CA3), // Track color
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
