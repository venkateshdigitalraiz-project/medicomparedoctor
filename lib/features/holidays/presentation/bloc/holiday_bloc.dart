import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/holidays/data/models/holiday_model.dart';

part 'holiday_event.dart';
part 'holiday_state.dart';

class HolidayBloc extends Bloc<HolidayEvent, HolidayState> {
  HolidayBloc() : super(HolidayState.initial()) {
    on<LoadHolidaysEvent>((event, emit) {
      emit(HolidayState.initial());
    });

    on<ToggleVacationModeEvent>((event, emit) {
      emit(state.copyWith(vacationModeActive: event.value));
    });

    on<ChangeMonthEvent>((event, emit) {
      final newMonth = DateTime(
        state.visibleMonth.year,
        state.visibleMonth.month + event.delta,
        1,
      );
      emit(state.copyWith(visibleMonth: newMonth));
    });

    on<SelectDateEvent>((event, emit) {
      emit(state.copyWith(selectedDate: event.date));
    });

    on<DeleteHolidayEvent>((event, emit) {
      final updated =
          state.holidays.where((h) => h.id != event.id).toList();
      emit(state.copyWith(holidays: updated));
    });

    on<AddHolidayEvent>((event, emit) {
      final updated = List<Holiday>.from(state.holidays)..add(event.holiday);
      emit(state.copyWith(holidays: updated));
    });

    on<AddCategoryEvent>((event, emit) {
      final updated = List<HolidayCategory>.from(state.categories)
        ..add(HolidayCategory(event.name));
      emit(state.copyWith(categories: updated));
    });

    on<SaveChangesEvent>((event, emit) async {
      emit(state.copyWith(isSaving: true, saveSuccess: false));
      await Future.delayed(const Duration(milliseconds: 700));
      emit(state.copyWith(isSaving: false, saveSuccess: true));
    });
  }
}
