import 'package:flutter/material.dart';

/// A single collapsible section header used for
/// Personal / Professional Information and Working Hours,
/// matching the purple-icon + chevron pattern in the design.
class UserSectionTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget? trailingChip; // e.g. the green "Available Now" chip
  final Widget? child; // expanded content
  final bool showDivider;

  const UserSectionTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    this.trailingChip,
    this.child,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Icon(leadingIcon, color: const Color(0xFF6C4FE0), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (trailingChip != null) ...[
                  trailingChip!,
                  const SizedBox(width: 8),
                ],
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: child ?? const SizedBox(width: double.infinity),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeInOut,
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Divider(color: Colors.grey.shade200, height: 1),
          ),
      ],
    );
  }
}

/// A single labeled row inside "Personal Information"
/// e.g. Mail ID / Phone Number / Gender.
class UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int? maxLines;

  const UserInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: maxLines,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
