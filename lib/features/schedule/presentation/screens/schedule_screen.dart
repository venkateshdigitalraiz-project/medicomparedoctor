import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicompare/common/common_add/appcolor.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/widget/circle_login_button.dart';
import 'package:medicompare/features/auth/logout/presentation/utils/logout_handler.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:medicompare/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:medicompare/features/schedule/data/models/appointment.dart';
import 'package:medicompare/features/schedule/presentation/widgets/appointment_card.dart';
import 'package:medicompare/features/schedule/presentation/widgets/date_selector.dart';
import 'package:medicompare/features/schedule/presentation/widgets/stat_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ScheduleView();
  }
}

class _ScheduleView extends StatefulWidget {
  const _ScheduleView();

  @override
  State<_ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<_ScheduleView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      const threshold = 200.0;
      if (current >= maxScroll - threshold) {
        final bloc = context.read<ScheduleBloc>();
        if (!bloc.state.isLoadingNextPage && !bloc.state.hasReachedEnd) {
          bloc.add(const LoadNextSchedulePage());
        }
      }
    }
  }

  Color _accentFor(AppointmentStatus status, int index) {
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
    final bloc = context.read<ScheduleBloc>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          buildWhen: (previous, current) =>
              (previous.status != current.status) ||
              (previous.errorMessage != current.errorMessage),
          builder: (context, state) {
            // Initial loading state (full-screen loader)
            if (state.status == ScheduleStatus.initialLoading ||
                state.status == ScheduleStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ScheduleStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? 'Error loading schedule',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ScheduleBloc>().add(const LoadSchedule());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 28, 0),
                  child: Row(
                    children: [
                      const SizedBox(width: 40),
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
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFEAEAF2)),
                    ),
                    child: Column(
                      children: [
                        // 1. HORIZONTAL CALENDAR (Only rebuilds when calendar data or selection changes)
                        BlocBuilder<ScheduleBloc, ScheduleState>(
                          buildWhen: (previous, current) =>
                              previous.selectedDateString !=
                                  current.selectedDateString ||
                              previous.calendar != current.calendar,
                          builder: (context, state) {
                            // Generate 5 days centered around today's date
                            final DateTime centerDate = DateTime.now();

                            // Generate 5 days centered around centerDate
                            final List<CalendarDay> fiveDaysList = [];
                            for (int i = -2; i <= 2; i++) {
                              final currentDay = centerDate.add(
                                Duration(days: i),
                              );
                              final formattedStr = DateFormat(
                                'yyyy-MM-dd',
                              ).format(currentDay);

                              // Try to find matching day in state.calendar to retain appointment count indicator
                              final match = state.calendar.firstWhere(
                                (d) => d.dateString == formattedStr,
                                orElse: () => CalendarDay(
                                  dayName: DateFormat('E').format(currentDay),
                                  date: currentDay.day,
                                  count: 0,
                                  dateString: formattedStr,
                                ),
                              );
                              fiveDaysList.add(match);
                            }

                            return DateSelector(
                              selectedDateString: state.selectedDateString,
                              week: fiveDaysList,
                              onDateSelected: (d) =>
                                  bloc.add(SelectCalendarDay(d)),
                              onTodayTap: () {
                                bloc.add(const JumpToToday());
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 18),

                        // 2. STAT CARDS (Only rebuilds when summary stats change)
                        BlocBuilder<ScheduleBloc, ScheduleState>(
                          buildWhen: (previous, current) =>
                              previous.stats != current.stats,
                          builder: (context, state) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.groups_2_rounded,
                                      color: AppColors.blue,
                                      value: state.stats.total,
                                      label: 'Total Appts',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.check_circle_rounded,
                                      color: AppColors.green,
                                      value: state.stats.confirmed,
                                      label: 'Confirmed',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.hourglass_bottom_rounded,
                                      color: AppColors.orange,
                                      value: state.stats.waiting,
                                      label: 'Waiting',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: StatCard(
                                      icon: Icons.close_rounded,
                                      color: AppColors.red,
                                      value: state.stats.cancelled,
                                      label: 'Cancelled',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 22),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
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

                        // 3. APPOINTMENTS LIST (Rebuilds only on appointments loading, pagination or appointment updates)
                        Expanded(
                          child: BlocBuilder<ScheduleBloc, ScheduleState>(
                            buildWhen: (previous, current) =>
                                previous.appointments != current.appointments ||
                                previous.isAppointmentsLoading !=
                                    current.isAppointmentsLoading ||
                                previous.isLoadingNextPage !=
                                    current.isLoadingNextPage,
                            builder: (context, state) {
                              final activeList = state.appointments;

                              // Log appointments list length inside UI builder
                              developer.log(
                                'UI BUILDER: active list length = ${activeList.length}',
                                name: 'ScheduleScreenUI',
                              );

                              if (state.isAppointmentsLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              Future<void> handleRefresh() async {
                                final sBloc = context.read<ScheduleBloc>();
                                if (sBloc.state.status ==
                                        ScheduleStatus.refreshing ||
                                    sBloc.state.status ==
                                        ScheduleStatus.initialLoading) {
                                  return;
                                }
                                final future = sBloc.stream.firstWhere(
                                  (st) =>
                                      st.status != ScheduleStatus.refreshing &&
                                      st.status !=
                                          ScheduleStatus.initialLoading,
                                );
                                sBloc.add(const RefreshSchedule());
                                await future;
                              }

                              if (activeList.isEmpty) {
                                return RefreshIndicator(
                                  onRefresh: handleRefresh,
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.4,
                                      child: const Center(
                                        child: Text(
                                          "No Appointments Found",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins",
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return RefreshIndicator(
                                onRefresh: handleRefresh,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    0,
                                    20,
                                    12,
                                  ),
                                  itemCount:
                                      activeList.length +
                                      (state.isLoadingNextPage ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == activeList.length) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                          ),
                                        ),
                                      );
                                    }
                                    final appt = activeList[index];
                                    return AppointmentCard(
                                      appointment: appt,
                                      accentColor: _accentFor(
                                        appt.status,
                                        index,
                                      ),
                                    );
                                  },
                                ),
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
