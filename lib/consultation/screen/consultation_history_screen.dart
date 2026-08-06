import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/consultation/screen/filter_tabs.dart';
import 'package:medicompare/consultation/screen/patient_card.dart';
import 'package:medicompare/consultation/screen/stat_item.dart';
import 'package:medicompare/core/routes/router_name.dart';

import '../bloc/consultation_bloc.dart';

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConsultationBloc()..add(const LoadConsultations()),
      child: const _ConsultationHistoryView(),
    );
  }
}

class _ConsultationHistoryView extends StatelessWidget {
  const _ConsultationHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocBuilder<ConsultationBloc, ConsultationState>(
                builder: (context, state) {
                  if (state.status == ConsultationStatusFlag.loading ||
                      state.status == ConsultationStatusFlag.initial) {
                    return Center(
                      child: AppLoader(
                        color: const Color(0xFF6D28D9),
                        size: 40,
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Column(
                            children: [
                              _SearchBar(),
                              const SizedBox(height: 16),
                              _StatsCard(state: state),
                              const SizedBox(height: 18),
                              FilterTabs(
                                selected: state.selectedFilter,
                                onSelected: (filter) => context
                                    .read<ConsultationBloc>()
                                    .add(FilterTabChanged(filter)),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      if (state.visibleConsultations.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No consultations found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final item = state.visibleConsultations[index];
                              return PatientCard(consultation: item);
                            }, childCount: state.visibleConsultations.length),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFE9EEFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D29)),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(
            child: Text(
              'Consultation History',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D29),
              ),
            ),
          ),
          const SizedBox(width: 48), // balances the back button
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEAEAF2)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) => context.read<ConsultationBloc>().add(
                      SearchQueryChanged(value),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.search);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name or ID',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAEAF2)),
          ),
          child: const Icon(Icons.tune, color: Color(0xFF6B3FF5), size: 20),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final ConsultationState state;
  const _StatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatItem(
            icon: Icons.assignment_outlined,
            iconColor: const Color(0xFF6B3FF5),
            iconBackground: const Color(0xFFF1E9FF),
            value: '${state.totalCount}',
            label: 'Total',
          ),
          _divider(),
          StatItem(
            icon: Icons.check,
            iconColor: const Color(0xFF2ECC71),
            iconBackground: const Color(0xFFE3FBEC),
            value: '${state.doneCount}',
            label: 'Done',
          ),
          _divider(),
          StatItem(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF4F7CFF),
            iconBackground: const Color(0xFFE9EEFF),
            value: '${state.upcomingCount}',
            label: 'Upcoming',
          ),
          _divider(),
          StatItem(
            icon: Icons.close,
            iconColor: const Color(0xFFFF5C5C),
            iconBackground: const Color(0xFFFFE9E9),
            value: '${state.cancelledCount}',
            label: 'Cancel',
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: const Color(0xFFEFEFF4));
}
