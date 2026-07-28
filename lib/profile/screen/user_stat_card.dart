import 'package:flutter/material.dart';
import 'package:medicompare/profile/model/user_profile_model.dart';

class UserStatCard extends StatelessWidget {
  final UserStatModel stat;

  const UserStatCard({super.key, required this.stat});

  IconData get _icon {
    switch (stat.iconAsset) {
      case 'patients':
        return Icons.groups_rounded;
      case 'appointments':
        return Icons.event_available_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorValue);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C4FE0), width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
