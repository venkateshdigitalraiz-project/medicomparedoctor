import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/add_available/bloc/add_avai_event.dart';
import 'package:medicompare/add_available/bloc/add_avai_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc() : super(AvailabilityState.initial()) {
    on<ToggleAvailability>(_toggleAvailability);

    on<ToggleWorkingDay>(_toggleWorkingDay);

    on<ChangeStartTime>(_changeStartTime);

    on<ChangeEndTime>(_changeEndTime);

    on<ChangeSlotDuration>(_changeSlotDuration);

    on<ToggleConsultationMode>(_toggleConsultationMode);

    on<ToggleVacationMode>(_toggleVacation);

    on<ChangeBreakTime>(_changeBreakTime);

    on<ChangeConsultationFee>(_changeFee);

    on<GeneratePreview>(_generatePreview);
  }

  void _toggleAvailability(
    ToggleAvailability event,
    Emitter<AvailabilityState> emit,
  ) {
    emit(state.copyWith(availableToday: !state.availableToday));
  }

  void _toggleWorkingDay(
    ToggleWorkingDay event,
    Emitter<AvailabilityState> emit,
  ) {
    final days = List<String>.from(state.selectedDays);

    if (days.contains(event.day)) {
      days.remove(event.day);
    } else {
      days.add(event.day);
    }

    emit(state.copyWith(selectedDays: days));
  }

  void _changeStartTime(
    ChangeStartTime event,
    Emitter<AvailabilityState> emit,
  ) {
    emit(state.copyWith(startTime: event.time));

    add(GeneratePreview());
  }

  void _changeEndTime(ChangeEndTime event, Emitter<AvailabilityState> emit) {
    emit(state.copyWith(endTime: event.time));

    add(GeneratePreview());
  }

  void _changeSlotDuration(
    ChangeSlotDuration event,
    Emitter<AvailabilityState> emit,
  ) {
    emit(state.copyWith(slotDuration: event.minutes));

    add(GeneratePreview());
  }

  void _toggleConsultationMode(
    ToggleConsultationMode event,
    Emitter<AvailabilityState> emit,
  ) {
    emit(state.copyWith(consultationMode: event.mode));
  }

  void _toggleVacation(
    ToggleVacationMode event,
    Emitter<AvailabilityState> emit,
  ) {
    emit(state.copyWith(vacationMode: !state.vacationMode));
  }

  void _changeBreakTime(
    ChangeBreakTime event,
    Emitter<AvailabilityState> emit,
  ) {
    emit(state.copyWith(breakTime: event.breakTime));

    add(GeneratePreview());
  }

  void _changeFee(
    ChangeConsultationFee event,
    Emitter<AvailabilityState> emit,
  ) {
    emit(state.copyWith(consultationFee: event.fee));
  }

  void _generatePreview(
    GeneratePreview event,
    Emitter<AvailabilityState> emit,
  ) {
    final slots = <TimeOfDay>[];

    int start = state.startTime.hour * 60 + state.startTime.minute;

    final end = state.endTime.hour * 60 + state.endTime.minute;

    while (start < end) {
      final time = TimeOfDay(hour: start ~/ 60, minute: start % 60);

      if (!state.breakTime.contains(time)) {
        slots.add(time);
      }

      start += state.slotDuration;
    }

    emit(state.copyWith(previewSlots: slots));
  }
}
