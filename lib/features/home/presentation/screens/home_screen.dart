import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:medicompare/core/widget/app_refresh_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/features/auth/logout/presentation/utils/logout_handler.dart';

import 'package:medicompare/core/theme/app_theme.dart';
import 'package:medicompare/core/widget/common_state_widgets.dart';
import 'package:medicompare/features/home/presentation/bloc/home_bloc.dart';
import 'package:medicompare/features/home/presentation/widgets/appointment_tile.dart';
import 'package:medicompare/features/home/presentation/widgets/clinic_status_card.dart';
import 'package:medicompare/features/home/presentation/widgets/dashboard_header.dart';
import 'package:medicompare/features/home/presentation/widgets/dashboard_search_bar.dart';
import 'package:medicompare/features/home/presentation/widgets/overview_stats_grid.dart';
import 'package:medicompare/features/home/presentation/widgets/quick_action_button.dart';
import 'package:medicompare/features/home/presentation/widgets/tab_selector.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

/// NOTE: This widget is now Stateful purely to own the ScrollController
/// and the section GlobalKeys. All app state (selectedTab, stats,
/// appointments, etc.) still lives in HomeBloc exactly as before —
/// nothing here bypasses or duplicates the Bloc's state.
class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  // How far from the top of the viewport a section's top edge must be
  // before we consider that section "active" while the user scrolls.
  static const double _activationOffset = 140.0;

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _overviewKey = GlobalKey(debugLabel: 'overviewSection');
  final GlobalKey _appointmentsKey = GlobalKey(
    debugLabel: 'appointmentsSection',
  );
  final GlobalKey _actionsKey = GlobalKey(debugLabel: 'actionsSection');

  // Guards against the scroll listener fighting with a tab-tap-triggered
  // programmatic scroll (ensureVisible also fires scroll notifications).
  bool _isProgrammaticScroll = false;

  // Avoids dispatching the same HomeTabChanged event repeatedly on every
  // scroll frame once a section is already marked active.
  HomeTab? _lastAutoDetectedTab;
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

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

  GlobalKey _keyForTab(HomeTab tab) {
    switch (tab) {
      case HomeTab.overview:
        return _overviewKey;
      case HomeTab.appointments:
        return _appointmentsKey;
      case HomeTab.actions:
        return _actionsKey;
    }
  }

  /// Called on every scroll notification while the user drags the list.
  /// Determines which section is currently "in focus" and — only if it
  /// differs from the last known tab — updates HomeBloc to keep the
  /// TabSelector in sync with manual scrolling.
  void _onScroll() {
    if (_isProgrammaticScroll) return;
    if (!mounted) return;

    // ── Pagination: fire HomeNextPageRequested when near the bottom ──────────
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      const threshold = 200.0;
      if (current >= maxScroll - threshold) {
        final bloc = context.read<HomeBloc>();
        if (!bloc.state.isLoadingNextPage && !bloc.state.hasReachedEnd) {
          bloc.add(const HomeNextPageRequested());
        }
      }
    }

    // ── Active Tab Detection ─────────────────────────────────────────────────
    HomeTab? activeTab;
    final overviewCtx = _overviewKey.currentContext;
    if (overviewCtx != null) {
      final box = overviewCtx.findRenderObject() as RenderBox?;
      if (box != null) {
        final offset = box.localToGlobal(Offset.zero);
        if (offset.dy <= _activationOffset) {
          activeTab = HomeTab.overview;
        }
      }
    }

    final apptsCtx = _appointmentsKey.currentContext;
    if (apptsCtx != null) {
      final box = apptsCtx.findRenderObject() as RenderBox?;
      if (box != null) {
        final offset = box.localToGlobal(Offset.zero);
        if (offset.dy <= _activationOffset) {
          activeTab = HomeTab.appointments;
        }
      }
    }

    final actionsCtx = _actionsKey.currentContext;
    if (actionsCtx != null) {
      final box = actionsCtx.findRenderObject() as RenderBox?;
      if (box != null) {
        final offset = box.localToGlobal(Offset.zero);
        if (offset.dy <= _activationOffset) {
          activeTab = HomeTab.actions;
        }
      }
    }

    activeTab ??= HomeTab.overview;

    if (activeTab != _lastAutoDetectedTab) {
      _lastAutoDetectedTab = activeTab;
      final bloc = context.read<HomeBloc>();
      if (bloc.state.selectedTab != activeTab) {
        bloc.add(HomeTabChanged(activeTab));
      }
    }
  }

  void _onTabTapped(BuildContext context, HomeTab tab) {
    // Keep Bloc as the single source of truth for selectedTab, exactly
    // as in the original implementation.
    context.read<HomeBloc>().add(HomeTabChanged(tab));
    switch (tab) {
      case HomeTab.overview:
        _scrollToSection(_overviewKey);
        break;

      case HomeTab.appointments:
        _scrollToSection(_appointmentsKey);
        break;

      case HomeTab.actions:
        _scrollToSection(_actionsKey);
        break;
    }
    //  _scrollToTab(tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: DashboardHeader(
                avatarUrl: 'https://i.pravatar.cc/300?img=45',
                onAvatarTap: () {
                  Navigator.pushNamed(context, RouteNames.menubar);
                },
                login: () {
                  LogoutHandler.logout(context);
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state.status == HomeStatus.failure &&
                      state.appointments.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? 'Refresh failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == HomeStatus.loading ||
                      state.status == HomeStatus.initial) {
                    return const CommonLoadingWidget();
                  }

                  if (state.status == HomeStatus.failure &&
                      state.appointments.isEmpty) {
                    return CommonErrorWidget(
                      message: state.errorMessage ?? 'Something went wrong',
                      onRetry: () =>
                          context.read<HomeBloc>().add(const HomeStarted()),
                    );
                  }

                  return AppRefreshIndicator(
                    color: Colors.green,
                    topposition: 4,
                    onRefresh: () async {
                      final bloc = context.read<HomeBloc>();
                      if (bloc.state.status == HomeStatus.loading) return;
                      final completer = Completer<void>();
                      bloc.add(HomeRefreshed(completer: completer));
                      await completer.future;
                    },
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        ClinicStatusCard(status: state.clinicStatus),
                        const SizedBox(height: 14),
                        DashboardSearchBar(
                          onChanged: (q) => context.read<HomeBloc>().add(
                            HomeSearchChanged(q),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TabSelector(
                          selected: state.selectedTab,
                          onTap: (tab) => _onTabTapped(context, tab),
                        ),
                        const SizedBox(height: 20),

                        // ---------------- Today's Overview ----------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              key: _overviewKey,
                              child: const Text(
                                "Today's Overview",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            OverviewStatsGrid(stats: state.stats),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ---------------- Today's Appointments ----------------
                        Container(
                          key: _appointmentsKey,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.infoBg.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
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
                                const CommonEmptyWidget(
                                  message: 'No appointments found',
                                )
                              else
                                ...state.filteredAppointments.map(
                                  (a) => AppointmentTile(appointment: a),
                                ),
                              // ── Pagination loading indicator ──────────────────
                              if (state.isLoadingNextPage)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: AppLoader(
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // ---------------- Quick Actions ----------------
                        Column(
                          key: _actionsKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.addavailable,
                                    );
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
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.holidays,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
