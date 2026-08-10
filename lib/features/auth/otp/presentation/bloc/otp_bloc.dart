import 'dart:async';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/auth/otp/domain/usecases/verify_otp_usecase.dart';
import 'package:medicompare/features/auth/otp/data/repositories/otp_repository_impl.dart';
import 'package:medicompare/features/auth/otp/data/datasources/otp_remote_data_source.dart';
import 'package:medicompare/core/network/global_client.dart';

import 'package:medicompare/core/services/session_manager.dart';

part 'otp_event.dart';
part 'otp_state.dart';

const int _otpDurationSeconds = 24;

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  Timer? _timer;

  OtpBloc({VerifyOtpUseCase? verifyOtpUseCase})
    : verifyOtpUseCase = verifyOtpUseCase ??
          VerifyOtpUseCase(
            OtpRepositoryImpl(
              remoteDataSource: OtpRemoteDataSourceImpl(
                client: AppHttpClient.dio,
              ),
            ),
          ),
      super(OtpState.initial()) {
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

    _startTimer();
  }

  Future<void> _onVerifySubmitted(
    OtpVerifySubmitted event,
    Emitter<OtpState> emit,
  ) async {
    if (state.status == OtpSubmissionStatus.submitting) {
      log("[OTP Flow] Duplicate verify attempt prevented.");
      return;
    }

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

    try {
      log("[OTP Flow] Clearing old session/token before new authentication...");
      await SessionManager.clearSession();

      log("[OTP Flow] Sending OTP verification request to API...");
      final response = await verifyOtpUseCase(
        phone: state.phoneNumber,
        otp: code,
      );

      log("[OTP Flow] OTP API response: success=${response.success}, message=${response.message}");

      if (response.success) {
        final token = response.data?.token;
        if (token == null || token.isEmpty) {
          log("[OTP Flow] Error: Token received is null or empty!");
          emit(
            state.copyWith(
              status: OtpSubmissionStatus.failure,
              errorMessage: 'Invalid response: token is missing or empty',
            ),
          );
          return;
        }

        log("[OTP Flow] Token received: $token");

        final userData =
            response.data?.employeePerson?.toJson() ??
            <String, dynamic>{'phone': state.phoneNumber};

        log("[OTP Flow] Saving token and user data to SharedPreferences...");
        await SessionManager.saveSession(token: token, userData: userData);
        log("[OTP Flow] Token saved.");

        log("[OTP Flow] Verifying token by reading it back from storage...");
        final savedToken = await SessionManager.getToken();
        log("[OTP Flow] Token read back: $savedToken");

        if (savedToken == null || savedToken.isEmpty || savedToken != token) {
          log("[OTP Flow] Error: Token read back does not match saved token!");
          emit(
            state.copyWith(
              status: OtpSubmissionStatus.failure,
              errorMessage: 'Session storage verification failed',
            ),
          );
          return;
        }

        log("[OTP Flow] Token successfully verified in storage. Emitting success state.");
        emit(
          state.copyWith(
            status: OtpSubmissionStatus.success,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: OtpSubmissionStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      log("[OTP Flow] Exception caught during verification: $e");
      emit(
        state.copyWith(
          status: OtpSubmissionStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
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
