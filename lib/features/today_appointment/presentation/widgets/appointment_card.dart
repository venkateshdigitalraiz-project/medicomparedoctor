import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/theme/app_theme.dart';
import 'package:medicompare/features/appointment_notes/presentation/widgets/appointment_notes_bottom_sheet.dart';
import 'package:medicompare/features/call/domain/entities/call_entity.dart';
import 'package:medicompare/features/call/presentation/bloc/call_bloc.dart';
import 'package:medicompare/features/call/presentation/bloc/call_event.dart';
import 'package:medicompare/features/call/presentation/pages/call_screen.dart';
import 'package:medicompare/features/today_appointment/domain/entities/today_appointment_entity.dart';

class AppointmentCard extends StatelessWidget {
  final TodayAppointmentEntity appointment;
  final Function(TodayAppointmentEntity)? onMoreTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onMoreTap,
  });

  Color get _accentColor {
    if (appointment.isConfirmed) {
      return const Color(0xFF6C4DF6);
    } else if (appointment.isCancelled) {
      return AppColors.danger;
    } else {
      return const Color(0xFFE8873A);
    }
  }

  void _startCall(BuildContext context, CallType callType) {
    final avatar = (appointment.avatarUrl.startsWith('http://') ||
            appointment.avatarUrl.startsWith('https://'))
        ? appointment.avatarUrl
        : null;

    final targetId = appointment.patientId.isNotEmpty
        ? appointment.patientId
        : (appointment.userId.isNotEmpty ? appointment.userId : appointment.id);

    context.read<CallBloc>().add(
          StartOutgoingCallEvent(
            targetUserId: targetId,
            targetUserName: appointment.displayName,
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
      patientName: appointment.displayName,
      existingNotes: appointment.notes,
      subtitle: appointment.formattedTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0F0F5)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left colored accent bar
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time column
                        SizedBox(
                          width: 58,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.formattedTime,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  fontFamily: "Poppins",
                                  color: Color(0xFF1F1F2E),
                                ),
                              ),
                              if (appointment.formattedDate.isNotEmpty)
                                Text(
                                  appointment.formattedDate,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF8A8A9C),
                                    fontFamily: "Poppins",
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Avatar / Initials
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFEFF6FF),
                          child: ClipOval(
                            child: (appointment.avatarUrl.startsWith('http://') ||
                                    appointment.avatarUrl.startsWith('https://'))
                                ? Image.network(
                                    appointment.avatarUrl,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => _buildInitials(),
                                  )
                                : _buildInitials(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Patient details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.displayName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F1F2E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  if (appointment.age > 0) ...[
                                    Text(
                                      '${appointment.age} yrs',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                        color: Color(0xFF8A8A9C),
                                      ),
                                    ),
                                    if (appointment.city.isNotEmpty)
                                      const Text(
                                        ' • ',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF8A8A9C),
                                        ),
                                      ),
                                  ],
                                  if (appointment.city.isNotEmpty)
                                    Expanded(
                                      child: Text(
                                        appointment.city,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Poppins",
                                          color: Color(0xFF8A8A9C),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                              if (appointment.phone.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_rounded,
                                      size: 11,
                                      color: Color(0xFF8A8A9C),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      appointment.phone,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontFamily: "Poppins",
                                        color: Color(0xFF8A8A9C),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Status badge + 3-dot popup menu + Notes button
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _StatusBadge(status: appointment.status),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _openNotes(context),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6C4DF6).withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFF6C4DF6).withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.edit_note_rounded,
                                          size: 13,
                                          color: Color(0xFF6C4DF6),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'Notes',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins",
                                            color: Color(0xFF6C4DF6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                PopupMenuButton<String>(
                                  color: Colors.white,
                                  elevation: 8,
                                  offset: const Offset(-10, 25),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onSelected: (value) {
                                    switch (value) {
                                      case "notes":
                                        _openNotes(context);
                                        break;
                                      case "details":
                                        Navigator.pushNamed(
                                          context,
                                          RouteNames.todayApartmentdtls,
                                          arguments: appointment.id,
                                        );
                                        break;
                                      case "audio":
                                        _startCall(context, CallType.audio);
                                        break;
                                      case "video":
                                        _startCall(context, CallType.video);
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: "notes",
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit_note_rounded,
                                            size: 18,
                                            color: Color(0xFF6C4DF6),
                                          ),
                                          SizedBox(width: 10),
                                          Text("Doctor Notes"),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: "details",
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.visibility_outlined,
                                            size: 18,
                                            color: Color(0xFF6C4DF6),
                                          ),
                                          SizedBox(width: 10),
                                          Text("View Details"),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: "audio",
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone_outlined,
                                            size: 18,
                                            color: Color(0xFF16A34A),
                                          ),
                                          SizedBox(width: 10),
                                          Text("Voice Call"),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: "video",
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.videocam_outlined,
                                            size: 18,
                                            color: Color(0xFF2563EB),
                                          ),
                                          SizedBox(width: 10),
                                          Text("Video Call"),
                                        ],
                                      ),
                                    ),
                                  ],
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      size: 18,
                                      color: Color(0xFF8A8A9C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (appointment.notes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => _openNotes(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFDDD6FE)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.description_outlined,
                                  size: 13,
                                  color: Color(0xFF6C4DF6),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  appointment.notes,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF4C1D95),
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 12,
                                  color: Color(0xFF6C4DF6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (appointment.message.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '"${appointment.message}"',
                          style: const TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF555566),
                            fontFamily: "Poppins",
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  Widget _buildInitials() {
    final initial = appointment.displayName.isNotEmpty
        ? appointment.displayName[0].toUpperCase()
        : 'P';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: "Poppins",
          color: Color(0xFF6C4DF6),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final String label;

    final lower = status.toLowerCase();

    if (lower == 'confirmed' || lower == 'completed') {
      bg = const Color(0xFFF1EBFF);
      fg = const Color(0xFF6C4DF6);
      label = lower == 'completed' ? 'Completed' : 'Confirmed';
    } else if (lower == 'cancelled') {
      bg = const Color(0xFFFFECEB);
      fg = const Color(0xFFDC2626);
      label = 'Cancelled';
    } else {
      bg = const Color(0xFFFDECDA);
      fg = const Color(0xFFE8873A);
      label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: "Poppins",
          color: fg,
        ),
      ),
    );
  }
}
