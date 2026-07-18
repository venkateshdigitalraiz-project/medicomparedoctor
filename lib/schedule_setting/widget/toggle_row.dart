import 'package:flutter/material.dart';

/// Row with an optional leading icon chip, a title, and a trailing switch.
/// Used for Consultation Types and Appointment Rules.
class ToggleRow extends StatelessWidget {
  final Widget? leading;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleRow({
    super.key,
    this.leading,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  static const Color purple = Color(0xFF601CA3);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: purple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Small rounded-square icon chip, e.g. the colored icon before
/// "In-Person", "Video Call", "Home Visit".
class IconChip extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;

  const IconChip({
    super.key,
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}
