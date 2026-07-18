import 'package:flutter/material.dart';
import '../models/analytics_data.dart';

/// Small circular-icon stat used in the top summary row.
class SummaryStatCard extends StatelessWidget {
  final SummaryStat stat;

  const SummaryStatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorValue);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(stat.icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 10),
        Text(
          stat.value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Poppins",
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stat.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8A8A9E),
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }
}

/// The purple gradient "Earnings Summary" card.
class EarningsSummaryCard extends StatelessWidget {
  final double monthlyRevenue;
  final double todayRevenue;
  final double weekRevenue;

  const EarningsSummaryCard({
    super.key,
    required this.monthlyRevenue,
    required this.todayRevenue,
    required this.weekRevenue,
  });

  String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A3DBE), Color(0xFF4E2A9A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A3DBE).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Revenue',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _fmt(monthlyRevenue),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniStat(label: 'Today', value: _fmt(todayRevenue)),
              ),
              Expanded(
                child: _MiniStat(label: 'This Week', value: _fmt(weekRevenue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// A single row in the "Performance Metrics" list.
class PerformanceMetricTile extends StatelessWidget {
  final PerformanceMetric metric;

  const PerformanceMetricTile({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFF4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(metric.iconBackgroundColorValue),
              shape: BoxShape.circle,
            ),
            child: Icon(
              metric.icon,
              color: Color(metric.iconColorValue),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metric.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: Color(0xFF8A8A9E),
                  ),
                ),
              ],
            ),
          ),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w800,
              color: Color(0xFF6A3DBE),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single row in the "Download Reports" list.
class ReportFileTile extends StatelessWidget {
  final ReportFile report;
  final VoidCallback? onDownload;

  const ReportFileTile({super.key, required this.report, this.onDownload});

  IconData get _fileIcon {
    switch (report.fileType) {
      case 'PDF':
        return Icons.picture_as_pdf_rounded;
      case 'CSV':
        return Icons.grid_on_rounded;
      default:
        return Icons.attach_money_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(report.accentColorValue);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(_fileIcon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              report.title,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          InkWell(
            onTap: onDownload,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.file_download_outlined,
                color: Color(0xFF6A3DBE),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable section header ("Earnings Summary", "Performance Metrics"...).
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }
}
