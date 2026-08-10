import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/features/auth/logout/domain/usecases/logout_usecase.dart';
import 'package:medicompare/features/auth/logout/presentation/bloc/logout_event.dart';
import 'package:medicompare/features/auth/logout/presentation/bloc/logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutBloc({required this.logoutUseCase}) : super(const LogoutInitial()) {
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  Future<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<LogoutState> emit,
  ) async {
    // Prevent multiple logout requests if user taps repeatedly
    if (state is LogoutLoading) return;

    emit(const LogoutLoading());

    try {
      // Call the API service via usecase
      await logoutUseCase();

      // Clear local SharedPreferences data
      await SessionManager.clearSession();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('refresh_token');
      await prefs.remove('fcm_token');

      emit(const LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
