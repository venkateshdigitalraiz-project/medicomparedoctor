import 'package:flutter/material.dart';
import 'package:medicompare/features/help_support/data/models/faq_item.dart';

/// A single FAQ row with an icon, question, expand arrow, and
/// an animated answer section.
class FaqTile extends StatelessWidget {
  final FaqItem item;
  final VoidCallback onTap;
  final bool showDivider;

  const FaqTile({
    super.key,
    required this.item,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFF1E9FE),
                  child: Icon(
                    item.icon,
                    color: const Color(0xFF601CA3),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: item.isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 44, right: 8, bottom: 10),
            child: Text(
              item.answer,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
          crossFadeState: item.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}
