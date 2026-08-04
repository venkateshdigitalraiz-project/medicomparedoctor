import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicompare/calendar/lib/bloc/calendar_bloc.dart';
import 'package:medicompare/calendar/lib/models/appointment.dart';
import 'package:medicompare/calendar/lib/widgets/calendar_popup.dart';
import 'package:medicompare/calendar/lib/widgets/timeline_item.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static final List<CalendarAppointment> _appointments = [
    const CalendarAppointment(
      name: 'Sarah Johnson',
      id: 'SJ-456789',
      time: '09:00 AM',
      date: '05 JULY 2026',
      type: 'Video call',
      accentColor: Color(0xFF7C3AED), // purple
    ),
    const CalendarAppointment(
      name: 'Sarah Johnson',
      id: 'SJ-456789',
      time: '09:00 AM',
      date: '05 JULY 2026',
      type: 'Video call',
      accentColor: Color(0xFF22C55E), // green
    ),
    const CalendarAppointment(
      name: 'Sarah Johnson',
      id: 'SJ-456789',
      time: '09:00 AM',
      date: '05 JULY 2026',
      type: 'Video call',
      accentColor: Color(0xFF2563EB), // blue
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthHeaderCard(context),
                    // The month grid expands/collapses INLINE, right here in
                    // the scroll flow — no dialog, no backdrop. It only takes
                    // up space (and becomes scrollable-into-view) once
                    // isPopupVisible is true.
                    BlocBuilder<CalendarBloc, CalendarState>(
                      buildWhen: (prev, curr) =>
                          prev.isPopupVisible != curr.isPopupVisible,
                      builder: (context, state) {
                        return AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          child: state.isPopupVisible
                              ? const CalendarGrid()
                              : const SizedBox(width: double.infinity),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAvailableTodayCard(),
                    const SizedBox(height: 24),
                    _buildTimelineHeader(),
                    const SizedBox(height: 16),
                    ...List.generate(_appointments.length, (i) {
                      return TimelineItem(
                        appointment: _appointments[i],
                        isFirst: i == 0,
                        isLast: i == _appointments.length - 1,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
          ),
          SizedBox(width: 40),
          const Text(
            'Calendar',
            style: TextStyle(
              fontSize: 22,
              fontFamily: "Poppins",
              wordSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Collapsed header: shows month/year + a couple of quick day chips
  /// around the selected date, WITHOUT the full grid. Tapping the pencil
  /// icon is the only way to open the full month-grid popup.
  Widget _buildMonthHeaderCard(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        final selected = state.selectedDate;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      DateFormat('MMMM').format(state.focusedMonth),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      DateFormat('yyyy').format(state.focusedMonth),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
              // Selected date pill (replaces the full grid in collapsed state)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  DateFormat('EEE, d MMM').format(selected),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Edit / pencil icon — ONLY trigger for the calendar popup
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => context.read<CalendarBloc>().add(
                  const ToggleCalendarPopup(),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E9FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvailableTodayCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E9FE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.door_front_door,
              color: Color(0xFF7C3AED),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Today',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '09:00 AM – 06:00 PM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7C3AED),
              side: const BorderSide(color: Color(0xFF601CA3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            ),
            onPressed: () {},
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Color(0xFF601CA3),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Timeline',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
        Icon(Icons.tune, color: Colors.grey.shade700),
      ],
    );
  }
}
