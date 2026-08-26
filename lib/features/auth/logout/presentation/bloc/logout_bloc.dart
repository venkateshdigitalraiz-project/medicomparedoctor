// ignore_for_file: prefer_conditional_assignment

import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/services/firebase_service.dart';

import 'package:medicompare/features/auth/logout/domain/usecases/logout_usecase.dart';
import 'package:medicompare/features/auth/logout/presentation/bloc/logout_event.dart';
import 'package:medicompare/features/auth/logout/presentation/bloc/logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutBloc({required this.logoutUseCase}) : super(const LogoutInitial()) {
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  Future<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<LogoutState> emit,
  ) async {
    // Prevent multiple logout requests.
    if (state is LogoutLoading) {
      return;
    }

    emit(const LogoutLoading());

    String? apiError;

    try {
      // -----------------------------------------------------------------------
      // CALL LOGOUT API
      // -----------------------------------------------------------------------

      await logoutUseCase();
    } on NetworkException catch (e) {
      // AppHttpClient already converts the original API/network error
      // into a friendly NetworkException.
      apiError = e.message;
    } catch (e) {
      // Do not expose raw exception details to the UI.
      apiError = 'Something went wrong. Please try again.';
    }

    // -------------------------------------------------------------------------
    // ALWAYS CLEAR LOCAL SESSION
    // -------------------------------------------------------------------------
    //
    // Even if logout API fails because of no internet/server error,
    // the user has explicitly requested logout.
    //
    // Clearing the local session prevents the user from remaining
    // locally authenticated.
    // -------------------------------------------------------------------------

    try {
      await PushNotificationManager.notificationService.deleteFCMToken();
    } catch (e) {
      developer.log('Failed to delete FCM token during logout: $e', name: 'LogoutBloc');
    }

    try {
      await SessionManager.clearSession();
    } catch (_) {
      // Session cleanup failure should not expose internal details.
      if (apiError == null) {
        apiError = 'Unable to clear the local session. Please try again.';
      }
    }

    // -------------------------------------------------------------------------
    // LOGOUT RESULT
    // -------------------------------------------------------------------------

    if (apiError == null) {
      emit(const LogoutSuccess());
    } else {
      emit(LogoutFailure(errorMessage: apiError));
    }
  }
}
