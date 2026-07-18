import 'package:flutter/material.dart';
import '../models/doctor_profile.dart';
import '../theme/app_theme.dart';

class ProfileHeaderCard extends StatelessWidget {
  final DoctorProfile profile;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSettingsTap;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    this.onBackTap,
    this.onNotificationsTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE9F0FE), Color(0xFFEFEAFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _IconCircle(icon: Icons.arrow_back_rounded, onTap: onBackTap),
              Row(
                children: [
                  _IconCircle(
                    icon: Icons.notifications_none_rounded,
                    onTap: onNotificationsTap,
                    filled: false,
                  ),
                  const SizedBox(width: 8),
                  _IconCircle(
                    icon: Icons.settings,
                    onTap: onSettingsTap,
                    filled: false,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(profile.avatarUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${profile.qualification} \u2022 ${profile.specialty}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'ID: ${profile.id}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _IconCircle({required this.icon, this.onTap, this.filled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, size: 22, color: AppColors.textDark),
      ),
    );
  }
}
