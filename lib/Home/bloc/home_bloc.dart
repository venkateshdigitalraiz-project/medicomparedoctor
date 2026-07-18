import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/appointment.dart';
import '../models/clinic_status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
    on<HomeSearchChanged>(_onSearchChanged);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeBottomNavChanged>(_onBottomNavChanged);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await _loadDashboard(emit);
  }

  Future<void> _onRefreshed(
      HomeRefreshed event, Emitter<HomeState> emit) async {
    await _loadDashboard(emit);
  }

  Future<void> _loadDashboard(Emitter<HomeState> emit) async {
    try {
      // Simulated network / repository call. Replace with a real
      // repository (e.g. HomeRepository.fetchDashboard()) in production.
      await Future.delayed(const Duration(milliseconds: 400));

      const clinicStatus = ClinicStatus(
        isAvailable: true,
        openTime: '09:00 AM',
        closeTime: '05:00 PM',
        capacityPercent: 0.9,
      );

      const stats = OverviewStats(
        totalAppointments: 24,
        completedVisits: 16,
        upcomingConsults: 8,
        cancelled: 2,
      );

      const appointments = [
        Appointment(
          id: '1',
          patientName: 'Marcus Williams',
          time: '09:30 AM',
          avatarUrl: 'https://i.pravatar.cc/150?img=12',
          status: AppointmentStatus.confirmed,
          type: AppointmentType.online,
        ),
        Appointment(
          id: '2',
          patientName: 'Sarah Jenkins',
          time: '10:15 AM',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          status: AppointmentStatus.waiting,
          type: AppointmentType.inPerson,
        ),
        Appointment(
          id: '3',
          patientName: 'Robert Fox',
          time: '10:45 AM',
          avatarUrl: 'https://i.pravatar.cc/150?img=33',
          status: AppointmentStatus.confirmed,
          type: AppointmentType.online,
        ),
      ];

      emit(state.copyWith(
        status: HomeStatus.success,
        clinicStatus: clinicStatus,
        stats: stats,
        appointments: appointments,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Could not load dashboard. Please try again.',
      ));
    }
  }

  void _onSearchChanged(HomeSearchChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onBottomNavChanged(
      HomeBottomNavChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(bottomNavIndex: event.index));
  }
}
