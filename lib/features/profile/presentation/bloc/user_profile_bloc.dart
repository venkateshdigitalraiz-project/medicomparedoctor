import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/core/network/global_client.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/ui/dialog_helper.dart';

import 'package:medicompare/features/profile/data/datasources/profile_api_service.dart';
import 'package:medicompare/features/profile/data/models/user_profile_model.dart';
import 'package:medicompare/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:medicompare/features/profile/domain/repositories/profile_repository.dart';
import 'package:medicompare/features/profile/presentation/bloc/user_profile_event.dart';
import 'package:medicompare/features/profile/presentation/bloc/user_profile_state.dart';

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

  // ---------------------------------------------------------------------------
  // LOAD / REFRESH PROFILE
  // ---------------------------------------------------------------------------

  Future<void> _onStarted(
    UserProfileStarted event,
    Emitter<UserProfileState> emit,
  ) async {
    DialogHelper.isAtLoginScreen = false;

    final current = state;

    // Keep existing profile visible during refresh.
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
          selectedNavItem: current is UserProfileLoaded
              ? current.selectedNavItem
              : UserBottomNavItem.profile,
        ),
      );
    }
    // -------------------------------------------------------------------------
    // CENTRALIZED NETWORK EXCEPTION
    // -------------------------------------------------------------------------
    on NetworkException catch (e, stackTrace) {
      // AppHttpClient has already converted the original error
      // into a friendly NetworkException.
      //
      // Examples:
      // - No internet
      // - Timeout
      // - Server error
      // - 401 / 403 / 404
      // - 500 / 502 / 503

      developer.log(
        'NetworkException while loading profile.',
        name: 'UserProfileBloc',
        error: e,
        stackTrace: stackTrace,
      );

      if (current is UserProfileLoaded) {
        // Keep old profile visible and only show refresh error.
        emit(current.copyWith(refreshError: e.message));
      } else {
        emit(UserProfileError(e.message));
      }
    }
    // -------------------------------------------------------------------------
    // DIO EXCEPTION
    // -------------------------------------------------------------------------
    on DioException catch (e, stackTrace) {
      developer.log(
        'DioException while loading profile.',
        name: 'UserProfileBloc',
        error: e,
        stackTrace: stackTrace,
      );

      String errorMessage = 'Something went wrong. Please try again.';

      if (e.error is NetworkException) {
        errorMessage = (e.error as NetworkException).message;
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }

      if (current is UserProfileLoaded) {
        emit(current.copyWith(refreshError: errorMessage));
      } else {
        emit(UserProfileError(errorMessage));
      }
    }
    // -------------------------------------------------------------------------
    // UNKNOWN EXCEPTION
    // -------------------------------------------------------------------------
    catch (e, stackTrace) {
      developer.log(
        'Unexpected exception while loading profile.',
        name: 'UserProfileBloc',
        error: e,
        stackTrace: stackTrace,
      );

      const errorMessage = 'Something went wrong. Please try again.';

      if (current is UserProfileLoaded) {
        emit(current.copyWith(refreshError: errorMessage));
      } else {
        emit(const UserProfileError(errorMessage));
      }
    }
    // -------------------------------------------------------------------------
    // COMPLETE REFRESH INDICATOR
    // -------------------------------------------------------------------------
    finally {
      if (event.completer != null && !event.completer!.isCompleted) {
        event.completer!.complete();
      }
    }
  }

  // ---------------------------------------------------------------------------
  // SECTION TOGGLE
  // ---------------------------------------------------------------------------

  void _onSectionToggled(
    UserProfileSectionToggled event,
    Emitter<UserProfileState> emit,
  ) {
    final current = state;

    if (current is! UserProfileLoaded) {
      return;
    }

    final expanded = Set<UserProfileSection>.from(current.expandedSections);

    if (expanded.contains(event.section)) {
      expanded.remove(event.section);
    } else {
      expanded.add(event.section);
    }

    emit(current.copyWith(expandedSections: expanded));
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ---------------------------------------------------------------------------

  void _onBottomNavTapped(
    UserBottomNavTapped event,
    Emitter<UserProfileState> emit,
  ) {
    final current = state;

    if (current is! UserProfileLoaded) {
      return;
    }

    emit(current.copyWith(selectedNavItem: event.item));
  }

  // ---------------------------------------------------------------------------
  // EDIT PROFILE
  // ---------------------------------------------------------------------------

  void _onEditRequested(
    UserProfileEditRequested event,
    Emitter<UserProfileState> emit,
  ) {
    // Navigation to Edit Profile is handled outside this Bloc.
  }
}
