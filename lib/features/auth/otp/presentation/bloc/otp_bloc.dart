import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/network/global_client.dart';

import 'package:medicompare/features/auth/otp/data/datasources/otp_remote_data_source.dart';
import 'package:medicompare/features/auth/otp/data/repositories/otp_repository_impl.dart';
import 'package:medicompare/features/auth/otp/domain/usecases/verify_otp_usecase.dart';

part 'otp_event.dart';
part 'otp_state.dart';

const int _otpDurationSeconds = 24;

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  Timer? _timer;

  OtpBloc({VerifyOtpUseCase? verifyOtpUseCase})
    : verifyOtpUseCase =
          verifyOtpUseCase ??
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

  // ---------------------------------------------------------------------------
  // OTP STARTED
  // ---------------------------------------------------------------------------

  void _onStarted(OtpStarted event, Emitter<OtpState> emit) {
    emit(OtpState.initial(phoneNumber: event.phoneNumber));

    _startTimer();
  }

  // ---------------------------------------------------------------------------
  // OTP DIGIT CHANGED
  // ---------------------------------------------------------------------------

  void _onDigitChanged(OtpDigitChanged event, Emitter<OtpState> emit) {
    final updated = List<String>.from(state.digits);

    if (event.index < 0 || event.index >= updated.length) {
      return;
    }

    updated[event.index] = event.value;

    emit(
      state.copyWith(
        digits: updated,
        status: OtpSubmissionStatus.idle,
        errorMessage: null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TIMER
  // ---------------------------------------------------------------------------

  void _onTimerTicked(OtpTimerTicked event, Emitter<OtpState> emit) {
    emit(
      state.copyWith(
        secondsRemaining: event.secondsRemaining,
        canResend: event.secondsRemaining <= 0,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RESEND OTP
  // ---------------------------------------------------------------------------

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    if (!state.canResend) {
      return;
    }

    emit(
      state.copyWith(
        digits: const ['', '', '', ''],
        status: OtpSubmissionStatus.idle,
        errorMessage: null,
      ),
    );

    _startTimer();
  }

  // ---------------------------------------------------------------------------
  // VERIFY OTP
  // ---------------------------------------------------------------------------

  Future<void> _onVerifySubmitted(
    OtpVerifySubmitted event,
    Emitter<OtpState> emit,
  ) async {
    // Prevent duplicate verification requests.
    if (state.status == OtpSubmissionStatus.submitting) {
      developer.log(
        'Duplicate OTP verification attempt prevented.',
        name: 'OtpBloc',
      );
      return;
    }

    // -------------------------------------------------------------------------
    // VALIDATE OTP LENGTH
    // -------------------------------------------------------------------------

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

    // -------------------------------------------------------------------------
    // VALIDATE OTP FORMAT
    // -------------------------------------------------------------------------

    if (!RegExp(r'^\d{4}$').hasMatch(code)) {
      emit(
        state.copyWith(
          status: OtpSubmissionStatus.failure,
          errorMessage: 'Please enter a valid 4 digit code',
        ),
      );
      return;
    }

    // -------------------------------------------------------------------------
    // START SUBMITTING
    // -------------------------------------------------------------------------

    emit(
      state.copyWith(
        status: OtpSubmissionStatus.submitting,
        errorMessage: null,
      ),
    );

    try {
      // -----------------------------------------------------------------------
      // CLEAR OLD SESSION
      // -----------------------------------------------------------------------

      developer.log(
        'Clearing previous authentication session.',
        name: 'OtpBloc',
      );

      await SessionManager.clearSession();

      // -----------------------------------------------------------------------
      // VERIFY OTP
      // -----------------------------------------------------------------------

      developer.log('Sending OTP verification request.', name: 'OtpBloc');

      final response = await verifyOtpUseCase(
        phone: state.phoneNumber,
        otp: code,
      );

      developer.log(
        'OTP API response received. success=${response.success}',
        name: 'OtpBloc',
      );

      // -----------------------------------------------------------------------
      // API SUCCESS
      // -----------------------------------------------------------------------

      if (response.success) {
        final token = response.data?.token;

        // Token is required for authentication.
        if (token == null || token.isEmpty) {
          developer.log(
            'OTP verification succeeded but token is missing.',
            name: 'OtpBloc',
          );

          emit(
            state.copyWith(
              status: OtpSubmissionStatus.failure,
              errorMessage: 'Invalid response: token is missing or empty',
            ),
          );

          return;
        }

        // ---------------------------------------------------------------------
        // USER DATA
        // ---------------------------------------------------------------------

        final userData =
            response.data?.employeePerson?.toJson() ??
            <String, dynamic>{'phone': state.phoneNumber};

        // ---------------------------------------------------------------------
        // SAVE SESSION
        // ---------------------------------------------------------------------

        developer.log('Saving authenticated session.', name: 'OtpBloc');

        await SessionManager.saveSession(token: token, userData: userData);

        // ---------------------------------------------------------------------
        // VERIFY SESSION STORAGE
        // ---------------------------------------------------------------------

        final savedToken = await SessionManager.getToken();

        if (savedToken == null || savedToken.isEmpty || savedToken != token) {
          developer.log(
            'Session storage verification failed.',
            name: 'OtpBloc',
          );

          emit(
            state.copyWith(
              status: OtpSubmissionStatus.failure,
              errorMessage: 'Session storage verification failed',
            ),
          );

          return;
        }

        developer.log(
          'Authentication session successfully saved.',
          name: 'OtpBloc',
        );

        // ---------------------------------------------------------------------
        // SUCCESS
        // ---------------------------------------------------------------------

        emit(
          state.copyWith(
            status: OtpSubmissionStatus.success,
            errorMessage: null,
          ),
        );
      }
      // -----------------------------------------------------------------------
      // API RETURNED FAILURE
      // -----------------------------------------------------------------------
      else {
        emit(
          state.copyWith(
            status: OtpSubmissionStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    }
    // -------------------------------------------------------------------------
    // CENTRALIZED NETWORK ERROR
    // -------------------------------------------------------------------------
    on NetworkException catch (e) {
      developer.log(
        'Network error during OTP verification.',
        name: 'OtpBloc',
        error: e,
      );

      emit(
        state.copyWith(
          status: OtpSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
    // -------------------------------------------------------------------------
    // UNKNOWN ERROR
    // -------------------------------------------------------------------------
    catch (e, stackTrace) {
      developer.log(
        'Unexpected error during OTP verification.',
        name: 'OtpBloc',
        error: e,
        stackTrace: stackTrace,
      );

      emit(
        state.copyWith(
          status: OtpSubmissionStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // START OTP TIMER
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // CLOSE
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;

    return super.close();
  }
}
