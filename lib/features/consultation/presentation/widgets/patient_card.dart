import 'package:flutter/material.dart';
import 'package:medicompare/features/consultation/data/models/consultation.dart';

class PatientCard extends StatelessWidget {
  final Consultation consultation;
  final VoidCallback? onTap;

  const PatientCard({super.key, required this.consultation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border(
                left: BorderSide(color: consultation.accentColor, width: 4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(consultation.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              consultation.patientName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins",
                                color: Color(0xFF1A1D29),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _IdBadge(id: consultation.id),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            color: Colors.grey.shade600,
                          ),
                          children: [
                            TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Poppins",
                                color: Colors.grey.shade600,
                              ),
                              text:
                                  '${consultation.age} • ${consultation.gender} • ',
                            ),
                            TextSpan(
                              text: 'Last visit: ${consultation.lastVisit}',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                color: consultation.isToday
                                    ? const Color(0xFF2ECC71)
                                    : Colors.grey.shade600,
                                fontWeight: consultation.isToday
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        consultation.conditions,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins",
                          color: Colors.grey.shade500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IdBadge extends StatelessWidget {
  final String id;
  const _IdBadge({required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'ID: $id',
        style: const TextStyle(
          fontSize: 10,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          color: Color(0xFF4F7CFF),
        ),
      ),
    );
  }
}
