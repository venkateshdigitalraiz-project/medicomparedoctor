import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/widget/circle_login_button.dart';
import 'package:medicompare/patients/bloc/patients_bloc.dart';
import 'package:medicompare/patients/bloc/patients_event.dart';
import 'package:medicompare/patients/bloc/patients_state.dart';
import 'package:medicompare/patients/widgets/filter_tab_bar.dart';
import 'package:medicompare/patients/widgets/patient_card.dart';
import 'package:medicompare/patients/widgets/stat_card.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FC),
      body: SafeArea(
        child: BlocBuilder<PatientsBloc, PatientsState>(
          builder: (context, state) {
            return Column(
              children: [
                _Header(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => context.read<PatientsBloc>().add(
                      const PatientsLoadRequested(),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0F0FF),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        border: Border.all(
                          color: const Color(0xFF9BC4ED), // Your border color
                          width: 2,
                        ),
                      ),
                      child: ListView(
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
                          if (state.status == PatientsStatus.loading)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (state.visiblePatients.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(child: Text('No patients found')),
                            )
                          else
                            // ...state.visiblePatients.map(
                            //   (p) => PatientCard(patient: p),
                            // ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFEFF6FF,
                                ), //Color(0xFFBED0F3),
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // optional
                                border: Border.all(
                                  color: const Color(
                                    0xFFBED0F3,
                                  ), // Your border color
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
          ///  const Icon(Icons.arrow_back, size: 22),
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
          SizedBox(width: 8),
          CircleIconButton(
            icon: Icons.logout,
            onTap: () {
              Navigator.pushNamed(context, RouteNames.login);
            },
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
