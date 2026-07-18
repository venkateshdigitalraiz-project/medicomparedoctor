import 'package:flutter_bloc/flutter_bloc.dart';

import 'pin_event.dart';
import 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  PinBloc() : super(const PinState()) {
    on<AddDigit>(_addDigit);

    on<RemoveDigit>(_removeDigit);

    on<ContinuePressed>(_continue);

    on<ResetPin>(_reset);

    on<VerifyPin>(_verifyPin);
    on<ShowKeypad>((event, emit) {
      emit(state.copyWith(showKeypad: true));
    });

    on<HideKeypad>((event, emit) {
      emit(state.copyWith(showKeypad: false));
    });
  }

  //-------------------------------------------------------
  // Add Number
  //-------------------------------------------------------

  void _addDigit(AddDigit event, Emitter<PinState> emit) {
    if (!state.isConfirmStep) {
      if (state.createPin.length >= 4) return;

      emit(state.copyWith(createPin: state.createPin + event.digit));
    } else {
      if (state.confirmPin.length >= 4) return;

      emit(state.copyWith(confirmPin: state.confirmPin + event.digit));

      if ((state.confirmPin + event.digit).length == 4) {
        add(VerifyPin());
      }
    }
  }

  //-------------------------------------------------------
  // Remove Number
  //-------------------------------------------------------

  void _removeDigit(RemoveDigit event, Emitter<PinState> emit) {
    if (!state.isConfirmStep) {
      if (state.createPin.isEmpty) return;

      emit(
        state.copyWith(
          createPin: state.createPin.substring(0, state.createPin.length - 1),
        ),
      );
    } else {
      if (state.confirmPin.isEmpty) return;

      emit(
        state.copyWith(
          confirmPin: state.confirmPin.substring(
            0,
            state.confirmPin.length - 1,
          ),
        ),
      );
    }
  }

  //-------------------------------------------------------
  // Continue
  //-------------------------------------------------------

  Future<void> _continue(ContinuePressed event, Emitter<PinState> emit) async {
    if (state.createPin.length != 4) return;

    emit(state.copyWith(isConfirmStep: true));
  }

  //-------------------------------------------------------
  // Verify
  //-------------------------------------------------------

  Future<void> _verifyPin(VerifyPin event, Emitter<PinState> emit) async {
    emit(state.copyWith(loading: true));

    await Future.delayed(const Duration(milliseconds: 800));

    if (state.createPin == state.confirmPin) {
      emit(state.copyWith(loading: false, success: true, error: ""));
    } else {
      emit(
        state.copyWith(
          loading: false,
          success: false,
          confirmPin: "",
          error: "PIN doesn't match",
        ),
      );
    }
  }

  //-------------------------------------------------------
  // Reset
  //-------------------------------------------------------

  void _reset(ResetPin event, Emitter<PinState> emit) {
    emit(const PinState());
  }
}
