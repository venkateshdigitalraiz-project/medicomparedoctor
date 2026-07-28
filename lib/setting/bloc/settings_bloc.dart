import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LogoutRequested>(_onLogoutRequested);
    on<SettingsItemTapped>(_onItemTapped);
    on<SettingsStatusReset>(_onStatusReset);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loggingOut));
    // Simulate a network/log-out call.
    await Future.delayed(const Duration(milliseconds: 600));
    await SessionManager.clearSession();
    emit(state.copyWith(status: SettingsStatus.loggedOut));
  }

  void _onItemTapped(
    SettingsItemTapped event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      status: SettingsStatus.navigating,
      activeItemKey: event.itemKey,
    ));
  }

  void _onStatusReset(
    SettingsStatusReset event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(status: SettingsStatus.initial));
  }
}
