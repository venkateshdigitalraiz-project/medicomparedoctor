import 'package:flutter/material.dart';

import 'package:medicompare/features/add_available/data/models/break_time_model.dart';
import 'package:medicompare/features/add_available/data/models/consultation_mode.dart';

class AvailabilityState {
  final bool availableToday;

  final List<String> selectedDays;

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final int slotDuration;

  final ConsultationMode consultationMode;

  final bool vacationMode;

  final BreakTimeModel breakTime;

  final String consultationFee;

  final List<TimeOfDay> previewSlots;

  const AvailabilityState({
    required this.availableToday,
    required this.selectedDays,
    required this.startTime,
    required this.endTime,
    required this.slotDuration,
    required this.consultationMode,
    required this.vacationMode,
    required this.breakTime,
    required this.consultationFee,
    required this.previewSlots,
  });

  factory AvailabilityState.initial() {
    return AvailabilityState(
      availableToday: true,
      selectedDays: const ["Mon", "Tue", "Wed", "Thu", "Fri"],
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 18, minute: 0),
      slotDuration: 30,
      consultationMode: ConsultationMode.clinic,
      vacationMode: false,
      breakTime: const BreakTimeModel(
        start: TimeOfDay(hour: 13, minute: 0),
        end: TimeOfDay(hour: 14, minute: 0),
      ),
      consultationFee: "",
      previewSlots: const [],
    );
  }

  AvailabilityState copyWith({
    bool? availableToday,
    List<String>? selectedDays,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? slotDuration,
    ConsultationMode? consultationMode,
    bool? vacationMode,
    BreakTimeModel? breakTime,
    String? consultationFee,
    List<TimeOfDay>? previewSlots,
  }) {
    return AvailabilityState(
      availableToday: availableToday ?? this.availableToday,
      selectedDays: selectedDays ?? this.selectedDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotDuration: slotDuration ?? this.slotDuration,
      consultationMode: consultationMode ?? this.consultationMode,
      vacationMode: vacationMode ?? this.vacationMode,
      breakTime: breakTime ?? this.breakTime,
      consultationFee: consultationFee ?? this.consultationFee,
      previewSlots: previewSlots ?? this.previewSlots,
    );
  }
}
