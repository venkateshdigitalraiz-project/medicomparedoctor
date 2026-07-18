import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/schedule_setting/model/schedule_models.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleSettingBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleSettingBloc() : super(const ScheduleState()) {
    on<ToggleAvailability>(_onToggleAvailability);
    on<ChangeTime>(_onChangeTime);
    on<ChangeSlotDuration>(_onChangeSlotDuration);
    on<ChangeBufferTime>(_onChangeBufferTime);
    on<ChangeMaxAppointments>(_onChangeMaxAppointments);
    on<ToggleConsultationType>(_onToggleConsultationType);
    on<ToggleAppointmentRule>(_onToggleAppointmentRule);
    on<RemoveBlockedSlot>(_onRemoveBlockedSlot);
    on<AddBlockedSlot>(_onAddBlockedSlot);
    on<ToggleVacationMode>(_onToggleVacationMode);
    on<AddHoliday>(_onAddHoliday);
    on<SaveScheduleSettings>(_onSaveScheduleSettings);
  }

  void _onToggleAvailability(
    ToggleAvailability event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(isCurrentlyAvailable: !state.isCurrentlyAvailable));
  }

  void _onChangeTime(ChangeTime event, Emitter<ScheduleState> emit) {
    switch (event.field) {
      case TimeField.morningStart:
        emit(state.copyWith(morningStart: event.value));
        break;
      case TimeField.morningEnd:
        emit(state.copyWith(morningEnd: event.value));
        break;
      case TimeField.eveningStart:
        emit(state.copyWith(eveningStart: event.value));
        break;
      case TimeField.eveningEnd:
        emit(state.copyWith(eveningEnd: event.value));
        break;
    }
  }

  void _onChangeSlotDuration(
    ChangeSlotDuration event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(slotDuration: event.value));
  }

  void _onChangeBufferTime(
    ChangeBufferTime event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(bufferTime: event.value));
  }

  void _onChangeMaxAppointments(
    ChangeMaxAppointments event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(maxAppointmentsPerDay: event.value));
  }

  void _onToggleConsultationType(
    ToggleConsultationType event,
    Emitter<ScheduleState> emit,
  ) {
    switch (event.type) {
      case ConsultationType.inPerson:
        emit(state.copyWith(inPersonEnabled: !state.inPersonEnabled));
        break;
      case ConsultationType.videoCall:
        emit(state.copyWith(videoCallEnabled: !state.videoCallEnabled));
        break;
      case ConsultationType.homeVisit:
        emit(state.copyWith(homeVisitEnabled: !state.homeVisitEnabled));
        break;
    }
  }

  void _onToggleAppointmentRule(
    ToggleAppointmentRule event,
    Emitter<ScheduleState> emit,
  ) {
    switch (event.rule) {
      case AppointmentRule.autoAccept:
        emit(state.copyWith(autoAcceptBookings: !state.autoAcceptBookings));
        break;
      case AppointmentRule.sameDayBooking:
        emit(state.copyWith(allowSameDayBooking: !state.allowSameDayBooking));
        break;
      case AppointmentRule.reschedulingAllowed:
        emit(state.copyWith(reschedulingAllowed: !state.reschedulingAllowed));
        break;
    }
  }

  void _onRemoveBlockedSlot(
    RemoveBlockedSlot event,
    Emitter<ScheduleState> emit,
  ) {
    final updated = state.blockedSlots.where((s) => s.id != event.id).toList();
    emit(state.copyWith(blockedSlots: updated));
  }

  void _onAddBlockedSlot(AddBlockedSlot event, Emitter<ScheduleState> emit) {
    emit(state.copyWith(blockedSlots: [...state.blockedSlots, event.slot]));
  }

  void _onToggleVacationMode(
    ToggleVacationMode event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(vacationMode: !state.vacationMode));
  }

  void _onAddHoliday(AddHoliday event, Emitter<ScheduleState> emit) {
    emit(state.copyWith(holidays: [...state.holidays, event.holiday]));
  }

  Future<void> _onSaveScheduleSettings(
    SaveScheduleSettings event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(saveStatus: SaveStatus.saving));
    try {
      // Simulate a network / repository call.
      await Future.delayed(const Duration(milliseconds: 600));
      emit(state.copyWith(saveStatus: SaveStatus.success));
    } catch (_) {
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }
}
