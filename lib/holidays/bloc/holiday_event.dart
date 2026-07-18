part of 'holiday_bloc.dart';

@immutable
abstract class HolidayEvent {}

class LoadHolidaysEvent extends HolidayEvent {}

class ToggleVacationModeEvent extends HolidayEvent {
  final bool value;
  ToggleVacationModeEvent(this.value);
}

class ChangeMonthEvent extends HolidayEvent {
  final int delta; // -1 previous, +1 next
  ChangeMonthEvent(this.delta);
}

class SelectDateEvent extends HolidayEvent {
  final DateTime date;
  SelectDateEvent(this.date);
}

class DeleteHolidayEvent extends HolidayEvent {
  final String id;
  DeleteHolidayEvent(this.id);
}

class AddHolidayEvent extends HolidayEvent {
  final Holiday holiday;
  AddHolidayEvent(this.holiday);
}

class AddCategoryEvent extends HolidayEvent {
  final String name;
  AddCategoryEvent(this.name);
}

class SaveChangesEvent extends HolidayEvent {}
