import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/appointment_notes/presentation/widgets/appointment_notes_bottom_sheet.dart';
import 'package:medicompare/features/call/domain/entities/call_entity.dart';
import 'package:medicompare/features/call/presentation/bloc/call_bloc.dart';
import 'package:medicompare/features/call/presentation/bloc/call_event.dart';
import 'package:medicompare/features/call/presentation/pages/call_screen.dart';
import 'package:medicompare/features/home/data/models/appointment.dart';
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

  void _startCall(BuildContext context, CallType callType) {
    final avatar =
        (appointment.avatarUrl.startsWith('http://') ||
                appointment.avatarUrl.startsWith('https://'))
            ? appointment.avatarUrl
            : null;

    final targetId = appointment.id;

    context.read<CallBloc>().add(
      StartOutgoingCallEvent(
        targetUserId: targetId,
        targetUserName: appointment.patientName,
        targetUserAvatar: avatar,
        callerName: 'Doctor',
        callType: callType,
        appointmentId: appointment.id,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CallScreen()),
    );
  }

  void _openNotes(BuildContext context) {
    showAppointmentNotesBottomSheet(
      context,
      appointmentId: appointment.id,
      patientName: appointment.patientName,
      subtitle: appointment.time,
    );
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
                      backgroundColor: const Color(0xFFEFF6FF),
                      child: ClipOval(
                        child: (appointment.avatarUrl.startsWith('http://') ||
                                appointment.avatarUrl.startsWith('https://'))
                            ? Image.network(
                                appointment.avatarUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      appointment.patientName.isNotEmpty
                                          ? appointment.patientName[0].toUpperCase()
                                          : 'P',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                        color: Color(0xFF6C4FE0),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  appointment.patientName.isNotEmpty
                                      ? appointment.patientName[0].toUpperCase()
                                      : 'P',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                    color: Color(0xFF6C4FE0),
                                  ),
                                ),
                              ),
                      ),
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
                        if (onMoreTap != null)
                          IconButton(
                            onPressed: onMoreTap,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.more_vert,
                              size: 18,
                              color: AppColors.textGrey,
                            ),
                          )
                        else
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              size: 18,
                              color: AppColors.textGrey,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            onSelected: (value) {
                              if (value == 'notes') {
                                _openNotes(context);
                              } else if (value == 'audio') {
                                _startCall(context, CallType.audio);
                              } else if (value == 'video') {
                                _startCall(context, CallType.video);
                              }
                            },
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem<String>(
                                    value: 'notes',
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF6C4CF1,
                                            ).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit_note_rounded,
                                            size: 18,
                                            color: Color(0xFF6C4CF1),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Doctor Notes',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF1F2333),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'audio',
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF6C4CF1,
                                            ).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.phone_rounded,
                                            size: 18,
                                            color: Color(0xFF6C4CF1),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Voice Call',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF1F2333),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'video',
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF34C759,
                                            ).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.videocam_rounded,
                                            size: 18,
                                            color: Color(0xFF34C759),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Video Call',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF1F2333),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
