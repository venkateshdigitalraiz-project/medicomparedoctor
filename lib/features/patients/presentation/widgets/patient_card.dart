import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicompare/features/call/domain/entities/call_entity.dart';
import 'package:medicompare/features/call/presentation/bloc/call_bloc.dart';
import 'package:medicompare/features/call/presentation/bloc/call_event.dart';
import 'package:medicompare/features/call/presentation/pages/call_screen.dart';
import 'package:medicompare/features/patients/data/models/patient.dart';

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
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CallScreen()),
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
                    Text(
                      'PID: ${patient.pid}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C4CF1),
                      ),
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                onSelected: (value) {
                  if (value == 'audio') {
                    _startCall(context, CallType.audio);
                  } else if (value == 'video') {
                    _startCall(context, CallType.video);
                  }
                },
                itemBuilder:
                    (context) => [
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
    );
  }
}
