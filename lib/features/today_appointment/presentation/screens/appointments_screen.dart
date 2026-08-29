import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/theme/app_theme.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:medicompare/core/widget/app_refresh_indicator.dart';
import 'package:medicompare/core/widget/common_state_widgets.dart';
import 'package:medicompare/features/today_appointment/presentation/bloc/appointment_bloc.dart';
import 'package:medicompare/features/today_appointment/presentation/bloc/appointment_event.dart';
import 'package:medicompare/features/today_appointment/presentation/bloc/appointment_state.dart';
import 'package:medicompare/features/today_appointment/presentation/widgets/appointment_card.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AppointmentsView();
  }
}

class _AppointmentsView extends StatefulWidget {
  const _AppointmentsView();

  @override
  State<_AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<_AppointmentsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Pending', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    const threshold = 200.0;

    if (current >= maxScroll - threshold) {
      final bloc = context.read<AppointmentBloc>();
      if (!bloc.state.isLoadingMore && !bloc.state.hasReachedEnd) {
        bloc.add(const LoadMoreTodayAppointments());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilterChips(context),
            Expanded(
              child: BlocConsumer<AppointmentBloc, AppointmentState>(
                listener: (context, state) {
                  if (state.status == AppointmentStatusFlag.failure &&
                      state.allAppointments.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? 'Request failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == AppointmentStatusFlag.loading ||
                      state.status == AppointmentStatusFlag.initial) {
                    return const Center(child: CommonLoadingWidget());
                  }

                  if (state.status == AppointmentStatusFlag.failure &&
                      state.allAppointments.isEmpty) {
                    return CommonErrorWidget(
                      message: state.errorMessage ?? 'Failed to load appointments',
                      onRetry: () => context
                          .read<AppointmentBloc>()
                          .add(const LoadTodayAppointments()),
                    );
                  }

                  return AppRefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      final bloc = context.read<AppointmentBloc>();
                      final completer = Completer<void>();
                      bloc.add(LoadTodayAppointments(completer: completer));
                      await completer.future;
                    },
                    child: state.visibleAppointments.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 80),
                              CommonEmptyWidget(
                                message: 'No appointments found',
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                            itemCount: state.visibleAppointments.length +
                                (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.visibleAppointments.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: AppLoader(
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                  ),
                                );
                              }

                              final appointment =
                                  state.visibleAppointments[index];
                              return AppointmentCard(
                                appointment: appointment,
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.maybePop(context),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.arrow_back_rounded, size: 24),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Today's Appointments",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: Color(0xFF1F1F2E),
                ),
              ),
              const Spacer(),
              BlocBuilder<AppointmentBloc, AppointmentState>(
                buildWhen: (prev, curr) => prev.total != curr.total,
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${state.total} Total',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Search Box
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Color(0xFF8A8A9C),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => context
                        .read<AppointmentBloc>()
                        .add(SearchTodayAppointments(value)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search by patient name, phone, or ID',
                      hintStyle: TextStyle(
                        color: Color(0xFF8A8A9C),
                        fontSize: 13,
                        fontFamily: "Poppins",
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      context
                          .read<AppointmentBloc>()
                          .add(const SearchTodayAppointments(''));
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: Color(0xFF8A8A9C),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      buildWhen: (prev, curr) => prev.selectedStatus != curr.selectedStatus,
      builder: (context, state) {
        final currentFilter = state.selectedStatus ?? 'All';

        return Container(
          height: 48,
          margin: const EdgeInsets.only(top: 8),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected =
                  currentFilter.toLowerCase() == filter.toLowerCase();

              return Center(
                child: InkWell(
                  onTap: () {
                    final newStatus = filter == 'All' ? null : filter;
                    context
                        .read<AppointmentBloc>()
                        .add(FilterTodayAppointmentsByStatus(newStatus));
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontFamily: "Poppins",
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
