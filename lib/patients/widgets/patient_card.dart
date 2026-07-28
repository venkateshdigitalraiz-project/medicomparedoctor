import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onMoreTap;

  const PatientCard({super.key, required this.patient, this.onMoreTap});
  String formatDate(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);

    return DateFormat('dd MMMM yyyy').format(parsedDate);
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
                backgroundImage: NetworkImage(patient.avatarUrl),
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
                        // Text(
                        //   patient.lastVisit,
                        //   style: const TextStyle(
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w600,
                        //     color: Color(0xFF1F2333),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onMoreTap,
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
