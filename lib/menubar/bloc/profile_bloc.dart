import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/doctor_profile.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileMenuItemTapped>(_onMenuItemTapped);
    on<ProfileNotificationsTapped>(_onNotificationsTapped);
    on<ProfileSettingsTapped>(_onSettingsTapped);
    on<ProfileNavigationHandled>(_onNavigationHandled);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      // Simulated repository call. Replace with a real profile repository.
      await Future.delayed(const Duration(milliseconds: 300));

      const profile = DoctorProfile(
        name: 'Dr. Sarah',
        qualification: 'MBBS, MD',
        specialty: 'Cardiologist',
        id: '876874577879',
        avatarUrl: 'https://i.pravatar.cc/300?img=45',
      );

      final menuItems = [
        MenuItem(
          id: 'availability',
          label: 'Availability & Schedule',
          icon: Icons.event_available_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.infoBg,
        ),
        MenuItem(
          id: 'clinic_info',
          label: 'Clinic Information',
          icon: Icons.local_hospital_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.infoBg,
        ),
        MenuItem(
          id: 'consultation_history',
          label: 'Consultation History',
          icon: Icons.assignment_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.infoBg,
        ),
        MenuItem(
          id: 'holidays_leave',
          label: 'Holidays & Leave',
          icon: Icons.calendar_month_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.infoBg,
        ),
        MenuItem(
          id: 'documents',
          label: 'Documents',
          icon: Icons.description_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.infoBg,
        ),
        MenuItem(
          id: 'reports_analytics',
          label: 'Reports & Analytics',
          icon: Icons.bar_chart_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.infoBg,
        ),
        MenuItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.infoBg,
          showChevron: true,
        ),
      ];

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          menuItems: menuItems,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Could not load profile. Please try again.',
        ),
      );
    }
  }

  void _onMenuItemTapped(
    ProfileMenuItemTapped event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(navigationTarget: event.itemId));
  }

  void _onNotificationsTapped(
    ProfileNotificationsTapped event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(navigationTarget: 'notifications'));
  }

  void _onSettingsTapped(
    ProfileSettingsTapped event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(navigationTarget: 'settings'));
  }

  void _onNavigationHandled(
    ProfileNavigationHandled event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(clearNavigationTarget: true));
  }
}
