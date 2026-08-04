import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarState.initial()) {
    on<ToggleCalendarPopup>(_onTogglePopup);
    on<CloseCalendarPopup>(_onClosePopup);
    on<SelectDate>(_onSelectDate);
    on<ChangeMonth>(_onChangeMonth);
  }

  void _onTogglePopup(ToggleCalendarPopup event, Emitter<CalendarState> emit) {
    emit(state.copyWith(isPopupVisible: !state.isPopupVisible));
  }

  void _onClosePopup(CloseCalendarPopup event, Emitter<CalendarState> emit) {
    emit(state.copyWith(isPopupVisible: false));
  }

  void _onSelectDate(SelectDate event, Emitter<CalendarState> emit) {
    // Only updates the selected date. The grid stays exactly as it was —
    // expanded/collapsed state is controlled solely by the edit icon.
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onChangeMonth(ChangeMonth event, Emitter<CalendarState> emit) {
    final next = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month + event.monthDelta,
    );
    emit(state.copyWith(focusedMonth: next));
  }
}
