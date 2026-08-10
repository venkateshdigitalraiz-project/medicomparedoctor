import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/features/auth/pin/presentation/bloc/pin_event.dart';
import 'package:medicompare/features/auth/pin/presentation/bloc/pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  PinBloc() : super(const PinState()) {
    on<PinChanged>(_onPinChanged);
    on<PinCleared>(_onPinCleared);
  }

  void _onPinChanged(PinChanged event, Emitter<PinState> emit) {
    // Keep only digits, and never exceed the max pin length.
    final digitsOnly = event.rawText.replaceAll(RegExp(r'[^0-9]'), '');
    final trimmed = digitsOnly.length > PinState.pinLength
        ? digitsOnly.substring(0, PinState.pinLength)
        : digitsOnly;

    emit(state.copyWith(pin: trimmed));
  }

  void _onPinCleared(PinCleared event, Emitter<PinState> emit) {
    emit(const PinState());
  }
}
