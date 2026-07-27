import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/common/common_add/appcolor.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/widget/circle_login_button.dart';
import 'package:medicompare/schedule/bloc/schedule_bloc.dart';
import 'package:medicompare/schedule/bloc/schedule_event.dart';
import 'package:medicompare/schedule/bloc/schedule_state.dart';
import 'package:medicompare/schedule/models/appointment.dart';
import 'package:medicompare/schedule/widgets/appointment_card.dart';
import 'package:medicompare/schedule/widgets/date_selector.dart';
import 'package:medicompare/schedule/widgets/stat_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ScheduleView();
  }
}
/*
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}
 */

class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  Color _accentFor(AppointmentStatus status, int index) {
    // Mirrors the varied accent-line colors seen in the reference design.
    const palette = [
      AppColors.orange,
      AppColors.blue,
      AppColors.purple,
      AppColors.red,
      AppColors.orange,
    ];
    return palette[index % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state.status == ScheduleStatus.loading ||
                state.status == ScheduleStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ScheduleStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Error'));
            }

            final bloc = context.read<ScheduleBloc>();

            return Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 28, 0),
                  child: Row(
                    children: [
                      //   const Icon(Icons.arrow_back, color: AppColors.textDark),
                      SizedBox(width: 40),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Schedule',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.sechduleSetting,
                          );
                        },
                        child: const Icon(
                          Icons.settings,
                          color: AppColors.textDark,
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
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFEAEAF2)),
                    ),
                    child: Column(
                      children: [
                        DateSelector(
                          selectedDate: state.selectedDate,
                          week: state.visibleWeek,
                          onDateSelected: (d) => bloc.add(SelectDate(d)),
                          onTodayTap: () => bloc.add(const JumpToToday()),
                        ),
                        const SizedBox(height: 18),

                        // Stat cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              StatCard(
                                icon: Icons.groups_2_rounded,
                                color: AppColors.blue,
                                value: state.stats.total,
                                label: 'Total Appts',
                              ),
                              const SizedBox(width: 10),
                              StatCard(
                                icon: Icons.check_circle_rounded,
                                color: AppColors.green,
                                value: state.stats.confirmed,
                                label: 'Confirmed',
                              ),
                              const SizedBox(width: 10),
                              const SizedBox(width: 10),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.hourglass_bottom_rounded,
                                  color: AppColors.orange,
                                  value: state.stats.waiting,
                                  label: 'Waiting',
                                ),
                              ),
                              StatCard(
                                icon: Icons.close_rounded,
                                color: AppColors.red,
                                value: state.stats.cancelled,
                                label: 'Cancelled',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Today's Schedule",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            itemCount: state.appointments.length,
                            itemBuilder: (context, index) {
                              final appt = state.appointments[index];
                              return AppointmentCard(
                                appointment: appt,
                                accentColor: _accentFor(appt.status, index),
                              );
                            },
                          ),
                        ),
                      ],
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
