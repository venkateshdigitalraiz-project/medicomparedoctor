import 'package:flutter/material.dart';

/// White rounded-corner card used throughout the screen, with a bordered
/// outline like the reference design.
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDEBF4)),
      ),
      child: child,
    );
  }
}

/// Section title row with an optional leading icon, used for headers like
/// "Consultation Hours", "Slot Configuration".
class SectionHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
  });

  static const Color purple = Color(0xFF601CA3);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: purple),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
