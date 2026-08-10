import 'package:equatable/equatable.dart';

class ClinicStatus extends Equatable {
  final bool isAvailable;
  final String openTime;
  final String closeTime;
  final double capacityPercent; // 0.0 - 1.0

  const ClinicStatus({
    required this.isAvailable,
    required this.openTime,
    required this.closeTime,
    required this.capacityPercent,
  });

  @override
  List<Object?> get props => [isAvailable, openTime, closeTime, capacityPercent];
}

class OverviewStats extends Equatable {
  final int totalAppointments;
  final int completedVisits;
  final int upcomingConsults;
  final int cancelled;

  const OverviewStats({
    required this.totalAppointments,
    required this.completedVisits,
    required this.upcomingConsults,
    required this.cancelled,
  });

  @override
  List<Object?> get props =>
      [totalAppointments, completedVisits, upcomingConsults, cancelled];
}
