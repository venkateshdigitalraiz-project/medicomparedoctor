import 'package:flutter/material.dart';

/// Simple immutable model representing one timeline entry.
class CalendarAppointment {
  final String name;
  final String id;
  final String time;
  final String date;
  final String type;
  final Color accentColor;
  final String? avatarUrl;

  const CalendarAppointment({
    required this.name,
    required this.id,
    required this.time,
    required this.date,
    required this.type,
    required this.accentColor,
    this.avatarUrl,
  });
}
