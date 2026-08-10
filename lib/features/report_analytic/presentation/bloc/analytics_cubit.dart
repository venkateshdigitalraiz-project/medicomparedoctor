import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/report_analytic/data/models/analytics_data.dart';
import 'package:medicompare/features/report_analytic/presentation/bloc/analytics_state.dart';

/// Cubit responsible for loading and holding the Reports & Analytics data.
///
/// In a real app, `_fetchAnalytics()` would call a repository/API instead
/// of returning mock data.
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(const AnalyticsLoading()) {
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    emit(const AnalyticsLoading());
    try {
      final data = await _fetchAnalytics();
      emit(AnalyticsLoaded(data));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  Future<void> refresh() => loadAnalytics();

  Future<AnalyticsData> _fetchAnalytics() async {
    // Simulate a network/database call.
    await Future.delayed(const Duration(milliseconds: 600));

    return AnalyticsData(
      summaryStats: [
        SummaryStat(
          value: '500',
          label: 'Total Patients',
          icon: Icons.badge_outlined,
          colorValue: const Color(0xFF9C6ADE).value,
        ),
        SummaryStat(
          value: '900',
          label: 'Total appt',
          icon: Icons.check_circle,
          colorValue: const Color(0xFF2ECC71).value,
        ),
        SummaryStat(
          value: '800',
          label: 'Completed',
          icon: Icons.calendar_month,
          colorValue: const Color(0xFF4A90E2).value,
        ),
        SummaryStat(
          value: '10',
          label: 'Cancelled',
          icon: Icons.close,
          colorValue: const Color(0xFFE74C3C).value,
        ),
      ],
      monthlyRevenue: 12450.00,
      todayRevenue: 420.50,
      weekRevenue: 3180.00,
      performanceMetrics: [
        PerformanceMetric(
          title: 'Avg Rating',
          subtitle: 'Based on 450 reviews',
          value: '4.9',
          icon: Icons.star_rounded,
          iconBackgroundColorValue: const Color(0xFFFFF3D6).value,
          iconColorValue: const Color(0xFFF5A623).value,
        ),
        PerformanceMetric(
          title: 'Patient Retention',
          subtitle: 'Returning visitors',
          value: '72%',
          icon: Icons.autorenew_rounded,
          iconBackgroundColorValue: const Color(0xFFE3E9FF).value,
          iconColorValue: const Color(0xFF4A5FE8).value,
        ),
        PerformanceMetric(
          title: 'Avg Duration',
          subtitle: 'Per consultation',
          value: '18m',
          icon: Icons.access_time_rounded,
          iconBackgroundColorValue: const Color(0xFFE3E9FF).value,
          iconColorValue: const Color(0xFF4A5FE8).value,
        ),
      ],
      reports: const [
        ReportFile(
          title: 'Appointment Report',
          fileType: 'PDF',
          accentColorValue: 0xFFE74C3C,
        ),
        ReportFile(
          title: 'Patient Database',
          fileType: 'CSV',
          accentColorValue: 0xFF2ECC71,
        ),
        ReportFile(
          title: 'Revenue Analysis',
          fileType: 'XLS',
          accentColorValue: 0xFF4A90E2,
        ),
      ],
    );
  }
}
