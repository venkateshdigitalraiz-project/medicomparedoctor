import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/network/error_mapper.dart';
import 'package:medicompare/core/ui/dialog_helper.dart';
import 'package:medicompare/features/profile/data/datasources/profile_api_service.dart';
import 'package:medicompare/features/profile/data/models/user_profile_model.dart';
import 'package:medicompare/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:medicompare/features/profile/domain/repositories/profile_repository.dart';
import 'package:medicompare/features/profile/presentation/bloc/user_profile_state.dart';
import 'package:medicompare/features/profile/presentation/bloc/user_profile_event.dart';

import 'package:medicompare/core/network/global_client.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository repository;

  UserProfileBloc({UserProfileRepository? repository})
    : repository =
          repository ??
          UserProfileRepositoryImpl(
            apiService: ProfileApiServiceImpl(client: AppHttpClient.dio),
          ),
      super(const UserProfileLoading()) {
    on<UserProfileStarted>(_onStarted);
    on<UserProfileSectionToggled>(_onSectionToggled);
    on<UserBottomNavTapped>(_onBottomNavTapped);
    on<UserProfileEditRequested>(_onEditRequested);
  }

  Future<void> _onStarted(
    UserProfileStarted event,
    Emitter<UserProfileState> emit,
  ) async {
    DialogHelper.isAtLoginScreen = false;
    final current = state;
    if (current is! UserProfileLoaded) {
      emit(const UserProfileLoading());
    } else {
      emit(current.copyWith(refreshError: null));
    }
    try {
      final profile = await repository.getUserProfile();
      emit(
        UserProfileLoaded(
          profile: profile,
          expandedSections: current is UserProfileLoaded
              ? current.expandedSections
              : const {UserProfileSection.personalInformation},
          selectedNavItem: UserBottomNavItem.profile,
        ),
      );
    } catch (e) {
      final String friendlyMessage;
      if (e is NetworkException) {
        friendlyMessage = e.message;
      } else if (e is DioException && e.error is NetworkException) {
        friendlyMessage = (e.error as NetworkException).message;
      } else if (e is SocketException) {
        friendlyMessage = ErrorMapper.mapNoInternet();
      } else if (e is TimeoutException) {
        friendlyMessage = ErrorMapper.mapTimeout();
      } else {
        friendlyMessage = ErrorMapper.mapUnknown();
      }
      if (current is UserProfileLoaded) {
        emit(current.copyWith(refreshError: friendlyMessage));
      } else {
        emit(UserProfileError(friendlyMessage));
      }
    } finally {
      event.completer?.complete();
    }
  }

  void _onSectionToggled(
    UserProfileSectionToggled event,
    Emitter<UserProfileState> emit,
  ) {
    final current = state;
    if (current is! UserProfileLoaded) return;

    final expanded = Set<UserProfileSection>.from(current.expandedSections);
    if (expanded.contains(event.section)) {
      expanded.remove(event.section);
    } else {
      expanded.add(event.section);
    }
    emit(current.copyWith(expandedSections: expanded));
  }

  void _onBottomNavTapped(
    UserBottomNavTapped event,
    Emitter<UserProfileState> emit,
  ) {
    final current = state;
    if (current is! UserProfileLoaded) return;
    emit(current.copyWith(selectedNavItem: event.item));
  }

  void _onEditRequested(
    UserProfileEditRequested event,
    Emitter<UserProfileState> emit,
  ) {
    // Hook point for navigating to an "Edit Profile" screen.
    // Left as a no-op here since it's outside the scope of this screen.
  }
}
