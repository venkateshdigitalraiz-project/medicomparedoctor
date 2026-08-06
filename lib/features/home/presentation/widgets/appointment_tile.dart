// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import '../../data/models/appointment.dart';
import 'package:medicompare/core/theme/app_theme.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onMoreTap;

  const AppointmentTile({super.key, required this.appointment, this.onMoreTap});

  Color get _sideBarColor {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return AppColors.primary;
      case AppointmentStatus.waiting:
        return AppColors.warning;
      case AppointmentStatus.cancelled:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              //  height: 72,
              decoration: BoxDecoration(
                color: _sideBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        appointment.time,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: AppColors.textDark,
                          height: 1.3,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.cardBorder,
                      backgroundImage: (appointment.avatarUrl.startsWith('http://') ||
                              appointment.avatarUrl.startsWith('https://'))
                          ? NetworkImage(appointment.avatarUrl)
                          : null,
                      child: !(appointment.avatarUrl.startsWith('http://') ||
                              appointment.avatarUrl.startsWith('https://'))
                          ? const Icon(Icons.person, size: 20)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.patientName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                appointment.type == AppointmentType.online
                                    ? Icons.videocam_rounded
                                    : Icons.location_on_rounded,
                                size: 13,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                appointment.type == AppointmentType.online
                                    ? 'Online'
                                    : 'In-person',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _StatusPill(status: appointment.status),
                        IconButton(
                          onPressed: onMoreTap,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.more_vert,
                            size: 18,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final AppointmentStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final String label;

    switch (status) {
      case AppointmentStatus.confirmed:
        bg = AppColors.infoBg;
        fg = AppColors.primary;
        label = 'Confirmed';
        break;
      case AppointmentStatus.waiting:
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        label = 'Waiting';
        break;
      case AppointmentStatus.cancelled:
        bg = AppColors.dangerBg;
        fg = AppColors.danger;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
