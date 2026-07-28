import 'package:equatable/equatable.dart';
import 'appointment.dart';
import 'clinic_status.dart';

// ---------------------------------------------------------------------------
// Top-level dashboard response
// ---------------------------------------------------------------------------
class DashboardResponse {
  final OverviewStats counts;
  final AppointmentPage todayAppointments;

  const DashboardResponse({
    required this.counts,
    required this.todayAppointments,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return DashboardResponse(
      counts: OverviewStats.fromJson(
        data['counts'] as Map<String, dynamic>? ?? {},
      ),
      todayAppointments: AppointmentPage.fromJson(
        data['todayAppointments'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Paginated appointment list
// ---------------------------------------------------------------------------
class AppointmentPage extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final List<Appointment> list;

  const AppointmentPage({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.list,
  });

  factory AppointmentPage.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'] as List<dynamic>? ?? [];
    return AppointmentPage(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 0,
      list: rawList
          .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [total, page, limit, totalPages, list];
}
