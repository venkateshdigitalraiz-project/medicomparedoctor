import 'package:flutter/material.dart';
import '../models/clinic_status.dart';
import '../theme/app_theme.dart';

class OverviewStatsGrid extends StatelessWidget {
  final OverviewStats stats;

  const OverviewStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.people_alt_rounded,
          iconColor: AppColors.info,
          iconBg: AppColors.infoBg,
          value: stats.totalAppointments.toString(),
          label: 'Total\nAppointments',
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.success,
            iconBg: AppColors.successBg,
            value: stats.completedVisits.toString(),
            label: 'Completed\nVisits',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.videocam_rounded,
            iconColor: Colors.red,
            iconBg: AppColors.warningBg,
            value: stats.upcomingConsults.toString(),
            label: 'Upcoming\nConsult',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.cancel_rounded,
            iconColor: AppColors.danger,
            iconBg: AppColors.dangerBg,
            value: stats.cancelled.toString(),
            label: 'Cancelled',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120,
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              //style: AppTextStyles.caption.copyWith(height: 1.2),
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
