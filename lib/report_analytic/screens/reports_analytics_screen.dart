import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';
import '../widgets/analytics_widgets.dart';

class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsCubit(),
      child: const _ReportsAnalyticsView(),
    );
  }
}

class _ReportsAnalyticsView extends StatelessWidget {
  const _ReportsAnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return Center(
                child: AppLoader(
                  color: const Color(0xFF6D28D9),
                  size: 40,
                ),
              );
            }
            if (state is AnalyticsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Something went wrong: ${state.message}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<AnalyticsCubit>().refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final data = (state as AnalyticsLoaded).data;

            return RefreshIndicator(
              onRefresh: () => context.read<AnalyticsCubit>().refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(),
                    const SizedBox(height: 20),
                    _SummaryStatsBar(stats: data.summaryStats),
                    const SizedBox(height: 28),
                    const SectionHeader(title: 'Earnings Summary'),
                    EarningsSummaryCard(
                      monthlyRevenue: data.monthlyRevenue,
                      todayRevenue: data.todayRevenue,
                      weekRevenue: data.weekRevenue,
                    ),
                    const SizedBox(height: 28),
                    const SectionHeader(title: 'Performance Metrics'),
                    ...data.performanceMetrics.map(
                      (m) => PerformanceMetricTile(metric: m),
                    ),
                    const SizedBox(height: 14),
                    const SectionHeader(title: 'Download Reports'),
                    ...data.reports.map(
                      (r) => ReportFileTile(
                        report: r,
                        onDownload: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading ${r.title}...'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Reports & Analytics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                'Manage leaves and clinic closures',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8A8A9E),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _SummaryStatsBar extends StatelessWidget {
  final List stats;

  const _SummaryStatsBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(stats.length, (i) {
          return Expanded(
            child: Row(
              children: [
                Expanded(child: SummaryStatCard(stat: stats[i])),
                if (i != stats.length - 1)
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFFEFEFF4),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
