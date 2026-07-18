import 'package:flutter/material.dart';
import 'package:medicompare/add_available/model/break_time_model.dart';
import 'package:medicompare/add_available/model/consultation_mode.dart';

abstract class AvailabilityEvent {}

class ToggleAvailability extends AvailabilityEvent {}

class ToggleWorkingDay extends AvailabilityEvent {
  final String day;

  ToggleWorkingDay(this.day);
}

class ChangeStartTime extends AvailabilityEvent {
  final TimeOfDay time;

  ChangeStartTime(this.time);
}

class ChangeEndTime extends AvailabilityEvent {
  final TimeOfDay time;

  ChangeEndTime(this.time);
}

class ChangeSlotDuration extends AvailabilityEvent {
  final int minutes;

  ChangeSlotDuration(this.minutes);
}

class ToggleConsultationMode extends AvailabilityEvent {
  final ConsultationMode mode;

  ToggleConsultationMode(this.mode);
}

class ToggleVacationMode extends AvailabilityEvent {}

class ChangeBreakTime extends AvailabilityEvent {
  final BreakTimeModel breakTime;

  ChangeBreakTime(this.breakTime);
}

class ChangeConsultationFee extends AvailabilityEvent {
  final String fee;

  ChangeConsultationFee(this.fee);
}

class GeneratePreview extends AvailabilityEvent {}

class SaveAvailability extends AvailabilityEvent {}
