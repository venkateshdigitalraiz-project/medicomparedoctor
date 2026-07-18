import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/holidays/bloc/holiday_bloc.dart';
import 'package:medicompare/holidays/widgets/calendar_widget.dart';
import 'package:medicompare/holidays/widgets/holiday_card.dart';
import 'package:medicompare/holidays/widgets/stat_card.dart';
import '../widgets/misc_widgets.dart';

const _purple = Color(0xFF601CA3);
const _purpleDark = Color(0xFF9D50BB);

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: BlocConsumer<HolidayBloc, HolidayState>(
        listener: (context, state) {
          if (state.saveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Changes saved successfully')),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVacationModeCard(context, state),
                        const SizedBox(height: 16),
                        _buildStatsGrid(state),
                        const SizedBox(height: 20),
                        _buildSectionHeader('Upcoming Holidays', () {}),
                        const SizedBox(height: 10),
                        ...state.upcomingHolidays
                            .take(3)
                            .map(
                              (h) => HolidayCard(
                                holiday: h,
                                onEdit: () {},
                                onDelete: () => context.read<HolidayBloc>().add(
                                  DeleteHolidayEvent(h.id),
                                ),
                              ),
                            ),
                        const SizedBox(height: 8),
                        CalendarWidget(
                          visibleMonth: state.visibleMonth,
                          selectedDate: state.selectedDate,
                          holidays: state.holidays,
                          onPrevMonth: () => context.read<HolidayBloc>().add(
                            ChangeMonthEvent(-1),
                          ),
                          onNextMonth: () => context.read<HolidayBloc>().add(
                            ChangeMonthEvent(1),
                          ),
                          onSelectDate: (d) => context.read<HolidayBloc>().add(
                            SelectDateEvent(d),
                          ),
                          onEdit: () {},
                          onDelete: () {},
                        ),
                        const SizedBox(height: 24),
                        _buildCategoriesSection(context, state),
                        const SizedBox(height: 24),
                        const Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Poppins",
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...state.recentActivity.asMap().entries.map(
                          (e) => ActivityTile(
                            item: e.value,
                            dotColor: e.key == 0
                                ? const Color(0xFF43A047)
                                : _purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<HolidayBloc, HolidayState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: const BoxDecoration(color: Color(0xFFF7F7FA)),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.isSaving
                    ? null
                    : () => context.read<HolidayBloc>().add(SaveChangesEvent()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purpleDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: state.isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(color: Color(0xFFEDF0FB)),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.arrow_back, size: 22),
          ),
          const SizedBox(width: 40),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Holidays',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Manage leaves and clinic closures',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVacationModeCard(BuildContext context, HolidayState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Vacation Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temporarily stop new \nappointments for a break',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: "poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: state.vacationModeActive,
            activeColor: Colors.white,
            activeTrackColor: Colors.greenAccent.shade400,
            onChanged: (v) =>
                context.read<HolidayBloc>().add(ToggleVacationModeEvent(v)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(HolidayState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.assignment_turned_in,
                iconColor: _purple,
                iconBgColor: const Color(0xFFEDE7F6),
                label: 'Total',
                value: state.totalCount.toString().padLeft(2, '0'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.wb_sunny,
                iconColor: const Color(0xFF00BFA5),
                iconBgColor: const Color(0xFFE0F7F4),
                label: 'Vacation',
                value: state.vacationCount.toString().padLeft(2, '0'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.flight,
                iconColor: const Color(0xFFFFA726),
                iconBgColor: const Color(0xFFFFF3E0),
                label: 'Upcoming',
                value: state.upcomingCount.toString().padLeft(2, '0'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.event_busy,
                iconColor: const Color(0xFFE53935),
                iconBgColor: const Color(0xFFFFEBEE),
                label: 'Blocked',
                value: state.blockedCount.toString().padLeft(2, '0'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        InkWell(
          onTap: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              color: _purple,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context, HolidayState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins",
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            InkWell(
              onTap: () => context.read<HolidayBloc>().add(
                AddCategoryEvent('New Category'),
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFF601CA3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: state.categories
              .map((c) => CategoryChip(label: c.name))
              .toList(),
        ),
      ],
    );
  }
}
