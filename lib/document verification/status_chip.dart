import 'package:flutter/material.dart';
import 'package:medicompare/document%20verification/document_model.dart';

class StatusChip extends StatelessWidget {
  final DocumentStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color textColor;
    late final String label;

    switch (status) {
      case DocumentStatus.pending:
        background = const Color(0xFFFFF1DC);
        textColor = const Color(0xFFE08A2E);
        label = 'Pending';
        break;
      case DocumentStatus.notUploaded:
        background = const Color(0xFFF1F1F4);
        textColor = const Color(0xFF9A9AA5);
        label = 'Not Uploaded';
        break;
      case DocumentStatus.selected:
        background = const Color(0xFFDFF6E8);
        textColor = const Color(0xFF2FAE6A);
        label = 'Selected';
        break;
      case DocumentStatus.approved:
        background = const Color(0xFFDFF6E8);
        textColor = const Color(0xFF2FAE6A);
        label = 'Approved';
        break;
      case DocumentStatus.rejected:
        background = const Color(0xFFFCE1E1);
        textColor = const Color(0xFFD64545);
        label = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
