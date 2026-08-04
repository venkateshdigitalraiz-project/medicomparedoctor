import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/widget/circle_login_button.dart';
import 'package:medicompare/features/auth/logout/presentation/utils/logout_handler.dart';
import 'package:medicompare/features/patients/presentation/bloc/patients_bloc.dart';
import 'package:medicompare/features/patients/presentation/bloc/patients_event.dart';
import 'package:medicompare/features/patients/presentation/bloc/patients_state.dart';
import 'package:medicompare/features/patients/presentation/widgets/filter_tab_bar.dart';
import 'package:medicompare/features/patients/presentation/widgets/patient_card.dart';
import 'package:medicompare/features/patients/presentation/widgets/stat_card.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<PatientsBloc>().state.status == PatientsStatus.initial) {
        context.read<PatientsBloc>().add(const PatientsLoadRequested());
      }
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      // Load more when user scrolls to bottom (100 pixels threshold)
      if (maxScroll - currentScroll <= 100) {
        context.read<PatientsBloc>().add(const PatientsLoadMoreRequested());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FC),
      body: SafeArea(
        child: BlocBuilder<PatientsBloc, PatientsState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.allPatients != current.allPatients ||
              previous.visiblePatients != current.visiblePatients ||
              previous.activeFilter != current.activeFilter ||
              previous.searchQuery != current.searchQuery ||
              previous.isLoadingMore != current.isLoadingMore ||
              previous.totalPatients != current.totalPatients ||
              previous.newThisMonth != current.newThisMonth ||
              previous.waitingPatientsCount != current.waitingPatientsCount ||
              previous.completedPatientsCount !=
                  current.completedPatientsCount ||
              previous.cancelledPatientsCount !=
                  current.cancelledPatientsCount ||
              previous.errorMessage != current.errorMessage,
          builder: (context, state) {
            return Column(
              children: [
                _Header(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<PatientsBloc>().add(
                        const PatientsLoadRequested(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F0FF),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        border: Border.all(
                          color: const Color(0xFF9BC4ED),
                          width: 2,
                        ),
                      ),
                      child: ListView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        children: [
                          _StatsRow(state: state),
                          const SizedBox(height: 16),
                          FilterTabBar(
                            activeFilter: state.activeFilter,
                            onChanged: (filter) => context
                                .read<PatientsBloc>()
                                .add(PatientsFilterChanged(filter)),
                          ),
                          const SizedBox(height: 16),
                          if (state.status == PatientsStatus.loading &&
                              state.allPatients.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (state.status == PatientsStatus.failure &&
                              state.allPatients.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text(
                                  state.errorMessage ?? 'Something went wrong',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            )
                          else if (state.visiblePatients.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(child: Text('No patients found')),
                            )
                          else
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFBED0F3),
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: state.visiblePatients
                                    .map((p) => PatientCard(patient: p))
                                    .toList(),
                              ),
                            ),
                          if (state.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Patients',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ),
                Center(
                  child: Text(
                    'Manage and monitor all patient records',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleIconButton(
                icon: Icons.logout,
                onTap: () {
                  LogoutHandler.logout(context);
                },
              ),
              const SizedBox(height: 4),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final PatientsState state;
  const _StatsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatCard(
          icon: Icons.groups_rounded,
          iconColor: const Color(0xFF6C4CF1),
          iconBg: const Color(0xFFEDE7FE),
          value: '${state.totalCount}'.padLeft(2, '0'),
          label: 'Total Patients',
        ),
        StatCard(
          icon: Icons.person_add_alt_1_rounded,
          iconColor: Colors.white,
          iconBg: const Color(0xFF34C759),
          value: '${state.newThisMonth}'.padLeft(2, '0'),
          label: 'New This\nMonth',
        ),
        StatCard(
          icon: Icons.replay_rounded,
          iconColor: const Color(0xFF2F80ED),
          iconBg: const Color(0xFFE7F0FF),
          value: '${state.waitingCount}'.padLeft(2, '0'),
          label: 'Waiting',
        ),
        StatCard(
          icon: Icons.close_rounded,
          iconColor: Colors.white,
          iconBg: const Color(0xFFEF4444),
          value: '${state.cancelledCount}'.padLeft(2, '0'),
          label: 'Cancelled',
        ),
      ],
    );
  }
}
