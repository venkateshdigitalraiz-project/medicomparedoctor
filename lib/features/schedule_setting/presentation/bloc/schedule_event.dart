import 'package:equatable/equatable.dart';
import 'package:medicompare/features/schedule_setting/data/models/schedule_models.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

/// Toggle the top "Currently Available" switch.
class ToggleAvailability extends ScheduleEvent {
  const ToggleAvailability();
}

/// Change one of the four time fields (morning/evening start/end).
class ChangeTime extends ScheduleEvent {
  final TimeField field;
  final String value;

  const ChangeTime(this.field, this.value);

  @override
  List<Object?> get props => [field, value];
}

/// Change slot duration, e.g. "15 Min", "30 Min".
class ChangeSlotDuration extends ScheduleEvent {
  final String value;
  const ChangeSlotDuration(this.value);

  @override
  List<Object?> get props => [value];
}

/// Change buffer time, e.g. "No Buffer", "5 Min".
class ChangeBufferTime extends ScheduleEvent {
  final String value;
  const ChangeBufferTime(this.value);

  @override
  List<Object?> get props => [value];
}

/// Change max appointments per day.
class ChangeMaxAppointments extends ScheduleEvent {
  final int value;
  const ChangeMaxAppointments(this.value);

  @override
  List<Object?> get props => [value];
}

/// Toggle a consultation type (In-Person / Video Call / Home Visit).
class ToggleConsultationType extends ScheduleEvent {
  final ConsultationType type;
  const ToggleConsultationType(this.type);

  @override
  List<Object?> get props => [type];
}

/// Toggle an appointment rule.
class ToggleAppointmentRule extends ScheduleEvent {
  final AppointmentRule rule;
  const ToggleAppointmentRule(this.rule);

  @override
  List<Object?> get props => [rule];
}

/// Remove a blocked slot by id.
class RemoveBlockedSlot extends ScheduleEvent {
  final String id;
  const RemoveBlockedSlot(this.id);

  @override
  List<Object?> get props => [id];
}

/// Add a new blocked slot.
class AddBlockedSlot extends ScheduleEvent {
  final BlockedSlot slot;
  const AddBlockedSlot(this.slot);

  @override
  List<Object?> get props => [slot];
}

/// Toggle "Vacation Mode" switch under Holidays & Leave.
class ToggleVacationMode extends ScheduleEvent {
  const ToggleVacationMode();
}

/// Add a new holiday.
class AddHoliday extends ScheduleEvent {
  final Holiday holiday;
  const AddHoliday(this.holiday);

  @override
  List<Object?> get props => [holiday];
}

/// Save button pressed - could trigger a repository/API call.
class SaveScheduleSettings extends ScheduleEvent {
  const SaveScheduleSettings();
}
