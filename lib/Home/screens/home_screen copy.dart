import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';

import '../bloc/home_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/appointment_tile.dart';
import '../widgets/clinic_status_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_search_bar.dart';
import '../widgets/overview_stats_grid.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/tab_selector.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading ||
                state.status == HomeStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == HomeStatus.failure) {
              return _ErrorView(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: () =>
                    context.read<HomeBloc>().add(const HomeStarted()),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<HomeBloc>().add(const HomeRefreshed()),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  DashboardHeader(
                    avatarUrl: 'https://i.pravatar.cc/150?img=47',
                    onAvatarTap: () {
                      Navigator.pushNamed(context, RouteNames.menubar);
                    },
                  ),
                  const SizedBox(height: 16),
                  ClinicStatusCard(status: state.clinicStatus),
                  const SizedBox(height: 14),
                  DashboardSearchBar(
                    onChanged: (q) =>
                        context.read<HomeBloc>().add(HomeSearchChanged(q)),
                  ),
                  const SizedBox(height: 14),
                  TabSelector(
                    selected: state.selectedTab,
                    onTap: (tab) {
                      context.read<HomeBloc>().add(HomeTabChanged(tab));
                      print("Tap current screen ${HomeTab.appointments}");
                      // if (tab == HomeTab.appointments) {
                      //   Navigator.pushNamed(context, RouteNames.todayApartment);
                      // }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Today's Overview",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OverviewStatsGrid(stats: state.stats),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.infoBg.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today's Appointments",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins",
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.todayApartment,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Poppins",
                                  color: Color(0xFF601CA3),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (state.filteredAppointments.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'No appointments found',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        else
                          ...state.filteredAppointments.map(
                            (a) => AppointmentTile(appointment: a),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      QuickActionButton(
                        icon: Icons.add_circle_outline_rounded,
                        label: 'Add\nAvailability',
                        color: AppColors.info,
                        bgColor: AppColors.infoBg,
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.addavailable);
                        },
                      ),
                      const SizedBox(width: 10),
                      QuickActionButton(
                        icon: Icons.assignment_outlined,
                        label: 'Consultation\nHistory',
                        color: AppColors.success,
                        bgColor: AppColors.successBg,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.consultationHistory,
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      QuickActionButton(
                        icon: Icons.event_note_rounded,
                        label: 'Holidays',
                        color: AppColors.primary,
                        bgColor: AppColors.infoBg,
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.holidays);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.danger),
          const SizedBox(height: 10),
          Text(message, style: AppTextStyles.body),
          const SizedBox(height: 14),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
