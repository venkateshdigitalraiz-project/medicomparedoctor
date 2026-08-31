import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicompare/features/appointment_notes/presentation/widgets/appointment_notes_bottom_sheet.dart';
import 'package:medicompare/features/call/domain/entities/call_entity.dart';
import 'package:medicompare/features/call/presentation/bloc/call_bloc.dart';
import 'package:medicompare/features/call/presentation/bloc/call_event.dart';
import 'package:medicompare/features/call/presentation/pages/call_screen.dart';
import 'package:medicompare/features/patients/data/models/patient.dart';
import 'package:medicompare/features/patients/presentation/bloc/patients_bloc.dart';
import 'package:medicompare/features/patients/presentation/bloc/patients_event.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onMoreTap;

  const PatientCard({super.key, required this.patient, this.onMoreTap});

  String formatDate(String dateTime) {
    try {
      final DateTime parsedDate = DateTime.parse(dateTime);
      return DateFormat('dd MMMM yyyy').format(parsedDate);
    } catch (_) {
      return dateTime;
    }
  }

  void _startCall(BuildContext context, CallType callType) {
    final avatar =
        (patient.avatarUrl.startsWith('http://') ||
                patient.avatarUrl.startsWith('https://'))
            ? patient.avatarUrl
            : null;

    final targetId = patient.userId.isNotEmpty ? patient.userId : patient.id;

    context.read<CallBloc>().add(
      StartOutgoingCallEvent(
        targetUserId: targetId,
        targetUserName: patient.name,
        targetUserAvatar: avatar,
        callerName: 'Doctor',
        callType: callType,
        appointmentId: patient.id.isNotEmpty ? patient.id : patient.pid,
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
      appointmentId: patient.id.isNotEmpty ? patient.id : patient.pid,
      patientName: patient.name,
      existingNotes: patient.notes,
      subtitle: 'PID: ${patient.pid}',
      onNotesSaved: () {
        try {
          context.read<PatientsBloc>().add(const PatientsLoadRequested());
        } catch (_) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E6F5)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage:
                    (patient.avatarUrl.startsWith('http://') ||
                            patient.avatarUrl.startsWith('https://'))
                        ? NetworkImage(patient.avatarUrl)
                        : null,
                child:
                    !(patient.avatarUrl.startsWith('http://') ||
                            patient.avatarUrl.startsWith('https://'))
                        ? const Icon(Icons.person, size: 26)
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        color: Color(0xFF1F2333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'PID: ${patient.pid}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6C4CF1),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${patient.age} Years  •  ${patient.gender}  •  ${patient.phone}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        color: Color(0xFF4B5162),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Last Visit : ${formatDate(patient.lastVisit)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
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
                  if (patient.notes.isEmpty) ...[
                    const SizedBox(height: 8),
                    // Direct 1-tap note button
                    InkWell(
                      onTap: () => _openNotes(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF6C4CF1,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFF6C4CF1,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.edit_note_rounded,
                              size: 14,
                              color: Color(0xFF6C4CF1),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Notes',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (patient.notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _openNotes(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.description_outlined,
                        size: 14,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        patient.notes,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 13,
                        color: Color(0xFF6C4CF1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
