import 'package:flutter/widgets.dart';

/// A single top-row summary stat (e.g. Total Patients, Total appt...).
class SummaryStat {
  final String value;
  final String label;
  final IconData icon;
  final int colorValue;

  const SummaryStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.colorValue,
  });
}

/// A single performance metric row (e.g. Avg Rating, Patient Retention...).
class PerformanceMetric {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final int iconBackgroundColorValue;
  final int iconColorValue;

  const PerformanceMetric({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.iconBackgroundColorValue,
    required this.iconColorValue,
  });
}

/// A downloadable report entry (e.g. Appointment Report, Patient Database...).
class ReportFile {
  final String title;
  final String fileType; // PDF, CSV, or $ (revenue)
  final int accentColorValue;

  const ReportFile({
    required this.title,
    required this.fileType,
    required this.accentColorValue,
  });
}

/// The full snapshot of data the Reports & Analytics screen renders.
class AnalyticsData {
  final List<SummaryStat> summaryStats;
  final double monthlyRevenue;
  final double todayRevenue;
  final double weekRevenue;
  final List<PerformanceMetric> performanceMetrics;
  final List<ReportFile> reports;

  const AnalyticsData({
    required this.summaryStats,
    required this.monthlyRevenue,
    required this.todayRevenue,
    required this.weekRevenue,
    required this.performanceMetrics,
    required this.reports,
  });
}
