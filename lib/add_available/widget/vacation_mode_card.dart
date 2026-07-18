import 'package:flutter/material.dart';

class VacationModeCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const VacationModeCard({
    super.key,
    required this.enabled,
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
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.beach_access_outlined,
              color: Color(0xff6D28D9),
            ),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vacation Mode",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),

                SizedBox(height: 6),

                Text(
                  "Disable appointment booking temporarily",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          Switch(
            value: enabled,
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
