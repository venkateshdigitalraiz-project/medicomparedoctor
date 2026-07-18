import 'package:flutter/material.dart';

/// Represents a single appointment/timeline entry shown at the
/// bottom of the Calendar screen (e.g. "Sarah Johnson - Video call").
class TimelineEvent {
  final String name;
  final String id;
  final String time;
  final String date;
  final String subtitle;
  final String avatarUrl;
  final Color accentColor;

  const TimelineEvent({
    required this.name,
    required this.id,
    required this.time,
    required this.date,
    required this.subtitle,
    required this.avatarUrl,
    required this.accentColor,
  });
}

/// Marks how a specific day on the calendar grid should be decorated.
enum DateMarkerType { none, busy, holiday, selected }

class DateMarker {
  final int day;
  final DateMarkerType type;

  const DateMarker(this.day, this.type);
}
