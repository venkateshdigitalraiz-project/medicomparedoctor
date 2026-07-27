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

    final Map<HomeTab, GlobalKey> sectionKeys = {
      HomeTab.overview: _overviewKey,
      HomeTab.appointments: _appointmentsKey,
      HomeTab.actions: _actionsKey,
    };

    HomeTab? activeTab;
    double bestTop = double.negativeInfinity;

    for (final entry in sectionKeys.entries) {
      final renderObject = entry.value.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) continue;

      final topOffset = renderObject.localToGlobal(Offset.zero).dy;

      // A section becomes the "active" candidate once its top has
      // scrolled up past the activation line. Among all sections that
      // qualify, we want the one with the largest (closest-to-top) dy,
      // i.e. the most recently passed section.
      if (topOffset <= _activationOffset && topOffset > bestTop) {
        bestTop = topOffset;
        activeTab = entry.key;
      }
    }

    // If nothing has passed the activation line yet (e.g. right at the
    // very top of the list), default to the first section.
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
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  DashboardHeader(
                    avatarUrl: 'https://i.pravatar.cc/150?img=47',
                    onAvatarTap: () {
                      Navigator.pushNamed(context, RouteNames.menubar);
                    },
                    login: () {
                      Navigator.pushNamed(context, RouteNames.login);
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
                              Navigator.pushNamed(context, RouteNames.holidays);
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
