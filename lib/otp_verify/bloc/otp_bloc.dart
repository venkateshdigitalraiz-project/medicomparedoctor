// import 'dart:async';

// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'otp_event.dart';
// part 'otp_state.dart';

// const int _otpDurationSeconds = 24;

// class OtpBloc extends Bloc<OtpEvent, OtpState> {
//   Timer? _timer;

//   OtpBloc() : super(OtpState.initial()) {
//     on<OtpStarted>(_onStarted);
//     on<OtpDigitChanged>(_onDigitChanged);
//     on<OtpTimerTicked>(_onTimerTicked);
//     on<OtpResendRequested>(_onResendRequested);
//     on<OtpVerifySubmitted>(_onVerifySubmitted);
//   }

//   void _onStarted(OtpStarted event, Emitter<OtpState> emit) {
//     emit(OtpState.initial(phoneNumber: event.phoneNumber));
//     _startTimer();
//   }

//   void _onDigitChanged(OtpDigitChanged event, Emitter<OtpState> emit) {
//     final updated = List<String>.from(state.digits);
//     updated[event.index] = event.value;
//     emit(
//       state.copyWith(
//         digits: updated,
//         status: OtpSubmissionStatus.idle,
//         errorMessage: null,
//       ),
//     );
//   }

//   void _onTimerTicked(OtpTimerTicked event, Emitter<OtpState> emit) {
//     emit(
//       state.copyWith(
//         secondsRemaining: event.secondsRemaining,
//         canResend: event.secondsRemaining == 0,
//       ),
//     );
//   }

//   Future<void> _onResendRequested(
//     OtpResendRequested event,
//     Emitter<OtpState> emit,
//   ) async {
//     if (!state.canResend) return;
//     emit(
//       state.copyWith(
//         digits: const ['', '', '', ''],
//         status: OtpSubmissionStatus.idle,
//         errorMessage: null,
//       ),
//     );
//     // TODO: trigger real "resend OTP" API call here.
//     _startTimer();
//   }

//   Future<void> _onVerifySubmitted(
//     OtpVerifySubmitted event,
//     Emitter<OtpState> emit,
//   ) async {
//     if (!state.isComplete) {
//       emit(state.copyWith(errorMessage: 'Please enter the full 4 digit code'));
//       return;
//     }

//     emit(
//       state.copyWith(
//         status: OtpSubmissionStatus.submitting,
//         errorMessage: null,
//       ),
//     );

//     await Future.delayed(const Duration(seconds: 1));
//     final isValid = state.code == '1568'; // placeholder check

//     emit(
//       state.copyWith(
//         status: isValid
//             ? OtpSubmissionStatus.success
//             : OtpSubmissionStatus.failure,
//         errorMessage: isValid ? null : 'Incorrect code. Please try again.',
//       ),
//     );
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     int remaining = _otpDurationSeconds;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       remaining -= 1;
//       if (remaining <= 0) {
//         timer.cancel();
//         add(const OtpTimerTicked(0));
//       } else {
//         add(OtpTimerTicked(remaining));
//       }
//     });
//   }

//   @override
//   Future<void> close() {
//     _timer?.cancel();
//     return super.close();
//   }
// }
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_event.dart';
part 'otp_state.dart';

const int _otpDurationSeconds = 24;

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  Timer? _timer;

  OtpBloc() : super(OtpState.initial()) {
    on<OtpStarted>(_onStarted);
    on<OtpDigitChanged>(_onDigitChanged);
    on<OtpTimerTicked>(_onTimerTicked);
    on<OtpResendRequested>(_onResendRequested);
    on<OtpVerifySubmitted>(_onVerifySubmitted);
  }

  void _onStarted(OtpStarted event, Emitter<OtpState> emit) {
    emit(OtpState.initial(phoneNumber: event.phoneNumber));
    _startTimer();
  }

  void _onDigitChanged(OtpDigitChanged event, Emitter<OtpState> emit) {
    final updated = List<String>.from(state.digits);

    updated[event.index] = event.value;

    emit(
      state.copyWith(
        digits: updated,
        status: OtpSubmissionStatus.idle,
        errorMessage: null,
      ),
    );
  }

  void _onTimerTicked(OtpTimerTicked event, Emitter<OtpState> emit) {
    emit(
      state.copyWith(
        secondsRemaining: event.secondsRemaining,
        canResend: event.secondsRemaining == 0,
      ),
    );
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    if (!state.canResend) return;

    emit(
      state.copyWith(
        digits: const ['', '', '', ''],
        status: OtpSubmissionStatus.idle,
        errorMessage: null,
      ),
    );

    // TODO: Call resend OTP API here.

    _startTimer();
  }

  Future<void> _onVerifySubmitted(
    OtpVerifySubmitted event,
    Emitter<OtpState> emit,
  ) async {
    // Check all 4 digits are entered
    if (!state.isComplete) {
      emit(
        state.copyWith(
          status: OtpSubmissionStatus.failure,
          errorMessage: 'Please enter the full 4 digit code',
        ),
      );
      return;
    }

    final code = state.code;

    // Accept only 4 numeric digits
    final isValid = RegExp(r'^\d{4}$').hasMatch(code);

    if (!isValid) {
      emit(
        state.copyWith(
          status: OtpSubmissionStatus.failure,
          errorMessage: 'Please enter a valid 4 digit code',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: OtpSubmissionStatus.submitting,
        errorMessage: null,
      ),
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Any 4-digit code is accepted
    emit(
      state.copyWith(status: OtpSubmissionStatus.success, errorMessage: null),
    );
  }

  void _startTimer() {
    _timer?.cancel();

    add(const OtpTimerTicked(_otpDurationSeconds));

    int remaining = _otpDurationSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;

      if (remaining <= 0) {
        timer.cancel();
        add(const OtpTimerTicked(0));
      } else {
        add(OtpTimerTicked(remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
