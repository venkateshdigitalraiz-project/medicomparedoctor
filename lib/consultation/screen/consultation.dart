import 'package:flutter/material.dart';

/// Status of a consultation.
enum ConsultationStatus { done, upcoming, cancelled }

/// Type of consultation, mirrors the filter tabs in the UI.
enum ConsultationType { videoCall, audioCall, inClinic }

/// Immutable model representing a single patient consultation entry.
class Consultation {
  final String id;
  final String patientName;
  final int age;
  final String gender;
  final String lastVisit;
  final bool isToday;
  final String conditions;
  final String avatarUrl;
  final Color accentColor;
  final ConsultationStatus status;
  final ConsultationType type;

  const Consultation({
    required this.id,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.lastVisit,
    required this.conditions,
    required this.avatarUrl,
    required this.accentColor,
    required this.status,
    required this.type,
    this.isToday = false,
  });
}
