import 'package:flutter/material.dart';
import 'package:medicompare/features/menubar/presentation/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String avatarUrl;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onAvatarTap;

  const DashboardHeader({
    super.key,
    required this.avatarUrl,
    this.onCalendarTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Medi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: '\nCompares',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  height: 0.9,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _CircleIconButton(icon: Icons.calendar_today_outlined, onTap: onCalendarTap),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onAvatarTap,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 19,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
