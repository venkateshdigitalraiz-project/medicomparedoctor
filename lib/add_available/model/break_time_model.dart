import 'package:flutter/material.dart';

class BreakTimeModel {
  final TimeOfDay start;
  final TimeOfDay end;

  const BreakTimeModel({required this.start, required this.end});

  BreakTimeModel copyWith({TimeOfDay? start, TimeOfDay? end}) {
    return BreakTimeModel(start: start ?? this.start, end: end ?? this.end);
  }

  bool contains(TimeOfDay time) {
    final current = time.hour * 60 + time.minute;
    final startMinute = start.hour * 60 + start.minute;
    final endMinute = end.hour * 60 + end.minute;

    return current >= startMinute && current < endMinute;
  }
}
