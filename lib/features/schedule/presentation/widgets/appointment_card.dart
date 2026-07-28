import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicompare/common/common_add/appcolor.dart';
import '../../data/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Color accentColor;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.accentColor,
  });

  Color get _statusColor {
    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        return AppColors.blue;
      case AppointmentStatus.waiting:
        return AppColors.orange;
      case AppointmentStatus.cancelled:
        return AppColors.red;
    }
  }

  String formatTime(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    return DateFormat('h:mm\na').format(parsedDate);
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  String get _modeLabel {
    switch (appointment.mode) {
      case AppointmentMode.inPerson:
        return 'In-person';
      case AppointmentMode.online:
        return 'Online';
      case AppointmentMode.linkExpired:
        return 'Link expired';
    }
  }

  IconData get _modeIcon {
    switch (appointment.mode) {
      case AppointmentMode.inPerson:
        return Icons.access_time_rounded;
      case AppointmentMode.online:
        return Icons.videocam_rounded;
      case AppointmentMode.linkExpired:
        return Icons.videocam_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = appointment.isCancelled;

    return Opacity(
      opacity: isCancelled ? 0.5 : 1,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              margin: const EdgeInsets.only(bottom: 16, right: 8, top: 8),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                appointment.time.isNotEmpty ? formatTime(appointment.time) : '',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ),

            // card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.chipBorder,
                          backgroundImage: NetworkImage(appointment.avatarUrl),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    appointment.patientName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      appointment.status.label,
                                      style: TextStyle(
                                        color: _statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    "${DateFormat('h:mma').format(DateTime.parse(appointment.time))} ",
                                    // formatTime(appointment.time),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  const Text(
                                    ' • ',
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                  Text(
                                    _modeLabel,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    _modeIcon,
                                    size: 14,
                                    color: AppColors.textGrey,
                                  ),
                                ],
                              ),
                              if (appointment.meetingLink != null)
                                Text(
                                  appointment.meetingLink.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    color: AppColors.blackColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (appointment.meetingLink != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.videocam_rounded,
                            size: 14,
                            color: AppColors.purple,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment.meetingLink!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.purple,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
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
