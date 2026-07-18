import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/schedule_setting/bloc/schedule_bloc.dart';
import 'package:medicompare/schedule_setting/bloc/schedule_event.dart';
import 'package:medicompare/schedule_setting/bloc/schedule_state.dart';
import 'package:medicompare/schedule_setting/model/schedule_models.dart';
import 'package:medicompare/schedule_setting/widget/section_card.dart';
import 'package:medicompare/schedule_setting/widget/time_dropdown.dart';
import 'package:medicompare/schedule_setting/widget/toggle_row.dart';

const Color kPurple = Color(0xFF601cA3);
const Color kBg = Color(0xFFF7F6FB);

const List<String> kHours = [
  '06:00 AM',
  '07:00 AM',
  '08:00 AM',
  '09:00 AM',
  '10:00 AM',
  '11:00 AM',
  '12:00 PM',
  '01:00 PM',
  '02:00 PM',
  '03:00 PM',
  '04:00 PM',
  '05:00 PM',
  '06:00 PM',
  '07:00 PM',
  '08:00 PM',
  '09:00 PM',
  '10:00 PM',
];

const List<String> kSlotDurations = ['15 Min', '30 Min', '45 Min', '60 Min'];
const List<String> kBufferOptions = ['No Buffer', '5 Min', '10 Min', '15 Min'];

class ScheduleSettingsScreen extends StatelessWidget {
  const ScheduleSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleSettingBloc(),
      child: const _ScheduleSettingsView(),
    );
  }
}

class _ScheduleSettingsView extends StatelessWidget {
  const _ScheduleSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: BlocListener<ScheduleSettingBloc, ScheduleState>(
        listenWhen: (prev, curr) => prev.saveStatus != curr.saveStatus,
        listener: (context, state) {
          if (state.saveStatus == SaveStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Schedule settings saved')),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      _AvailabilityCard(),
                      SizedBox(height: 16),
                      _ConsultationHoursCard(),
                      SizedBox(height: 16),
                      _SlotConfigurationCard(),
                      SizedBox(height: 16),
                      _ConsultationTypesCard(),
                      SizedBox(height: 16),
                      _AppointmentRulesCard(),
                      SizedBox(height: 16),
                      _BlockedSlotsCard(),
                      SizedBox(height: 16),
                      _ScheduleSummaryCard(),
                      SizedBox(height: 16),
                      _HolidaysCard(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE7ECFB), kBg],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 16),
          const Text(
            'Schedule Settings',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "POppins",
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      color: kBg,
      child: BlocBuilder<ScheduleSettingBloc, ScheduleState>(
        buildWhen: (prev, curr) => prev.saveStatus != curr.saveStatus,
        builder: (context, state) {
          final saving = state.saveStatus == SaveStatus.saving;
          return SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: saving
                  ? null
                  : () => context.read<ScheduleSettingBloc>().add(
                      const SaveScheduleSettings(),
                    ),
              child: saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Save Schedule Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

/// ------------------------- Currently Available -------------------------
class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) =>
          prev.isCurrentlyAvailable != curr.isCurrentlyAvailable ||
          prev.lastUpdated != curr.lastUpdated,
      builder: (context, state) {
        return SectionCard(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F7EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_available,
                  color: Color(0xFF1FAA59),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Currently Available',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last updated: ${state.lastUpdated}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: state.isCurrentlyAvailable,
                activeColor: Colors.white,
                activeTrackColor: kPurple,
                onChanged: (_) => context.read<ScheduleSettingBloc>().add(
                  const ToggleAvailability(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ------------------------- Consultation Hours -------------------------
class _ConsultationHoursCard extends StatelessWidget {
  const _ConsultationHoursCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) =>
          prev.morningStart != curr.morningStart ||
          prev.morningEnd != curr.morningEnd ||
          prev.eveningStart != curr.eveningStart ||
          prev.eveningEnd != curr.eveningEnd,
      builder: (context, state) {
        final bloc = context.read<ScheduleSettingBloc>();
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: Icons.access_time,
                title: 'Consultation Hours',
              ),
              const SizedBox(height: 14),
              const Text(
                'Morning Session',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TimeDropdownField(
                      label: 'Start Time',
                      value: state.morningStart,
                      options: kHours,
                      onChanged: (v) =>
                          bloc.add(ChangeTime(TimeField.morningStart, v)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TimeDropdownField(
                      label: 'End Time',
                      value: state.morningEnd,
                      options: kHours,
                      onChanged: (v) =>
                          bloc.add(ChangeTime(TimeField.morningEnd, v)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Evening Session',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TimeDropdownField(
                      label: 'Start Time',
                      value: state.eveningStart,
                      options: kHours,
                      onChanged: (v) =>
                          bloc.add(ChangeTime(TimeField.eveningStart, v)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TimeDropdownField(
                      label: 'End Time',
                      value: state.eveningEnd,
                      options: kHours,
                      onChanged: (v) =>
                          bloc.add(ChangeTime(TimeField.eveningEnd, v)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ------------------------- Slot Configuration -------------------------
class _SlotConfigurationCard extends StatelessWidget {
  const _SlotConfigurationCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) =>
          prev.slotDuration != curr.slotDuration ||
          prev.bufferTime != curr.bufferTime ||
          prev.maxAppointmentsPerDay != curr.maxAppointmentsPerDay,
      builder: (context, state) {
        final bloc = context.read<ScheduleSettingBloc>();
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: Icons.tune,
                title: 'Slot Configuration',
              ),
              const Divider(height: 24),
              InlineDropdownRow(
                label: 'Slot Duration',
                value: state.slotDuration,
                options: kSlotDurations,
                onChanged: (v) => bloc.add(ChangeSlotDuration(v)),
              ),
              InlineDropdownRow(
                label: 'Buffer Time',
                value: state.bufferTime,
                options: kBufferOptions,
                onChanged: (v) => bloc.add(ChangeBufferTime(v)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Max Appointments/Day',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 20,
                        color: kPurple,
                      ),
                      onPressed: () => bloc.add(
                        ChangeMaxAppointments(
                          (state.maxAppointmentsPerDay - 1).clamp(1, 999),
                        ),
                      ),
                    ),
                    Text(
                      '${state.maxAppointmentsPerDay}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        color: kPurple,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: kPurple,
                      ),
                      onPressed: () => bloc.add(
                        ChangeMaxAppointments(
                          (state.maxAppointmentsPerDay + 1).clamp(1, 999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ------------------------- Consultation Types -------------------------
class _ConsultationTypesCard extends StatelessWidget {
  const _ConsultationTypesCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) =>
          prev.inPersonEnabled != curr.inPersonEnabled ||
          prev.videoCallEnabled != curr.videoCallEnabled ||
          prev.homeVisitEnabled != curr.homeVisitEnabled,
      builder: (context, state) {
        final bloc = context.read<ScheduleSettingBloc>();
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Consultation Types',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ToggleRow(
                leading: const IconChip(
                  icon: Icons.person_outline,
                  background: Color(0xFFE7ECFB),
                  iconColor: Color(0xFF4A6CF7),
                ),
                title: 'In-Person',
                value: state.inPersonEnabled,
                onChanged: (_) => bloc.add(
                  const ToggleConsultationType(ConsultationType.inPerson),
                ),
              ),
              ToggleRow(
                leading: const IconChip(
                  icon: Icons.videocam_outlined,
                  background: Color(0xFFE4F7EA),
                  iconColor: Color(0xFF1FAA59),
                ),
                title: 'Video Call',
                value: state.videoCallEnabled,
                onChanged: (_) => bloc.add(
                  const ToggleConsultationType(ConsultationType.videoCall),
                ),
              ),
              ToggleRow(
                leading: const IconChip(
                  icon: Icons.home_outlined,
                  background: Color(0xFFFBEFE1),
                  iconColor: Color(0xFFDB7C1D),
                ),
                title: 'Home Visit',
                value: state.homeVisitEnabled,
                onChanged: (_) => bloc.add(
                  const ToggleConsultationType(ConsultationType.homeVisit),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ------------------------- Appointment Rules -------------------------
class _AppointmentRulesCard extends StatelessWidget {
  const _AppointmentRulesCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) =>
          prev.autoAcceptBookings != curr.autoAcceptBookings ||
          prev.allowSameDayBooking != curr.allowSameDayBooking ||
          prev.reschedulingAllowed != curr.reschedulingAllowed,
      builder: (context, state) {
        final bloc = context.read<ScheduleSettingBloc>();
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appointment Rules',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              ToggleRow(
                title: 'Auto-Accept Bookings',
                value: state.autoAcceptBookings,
                onChanged: (_) => bloc.add(
                  const ToggleAppointmentRule(AppointmentRule.autoAccept),
                ),
              ),
              ToggleRow(
                title: 'Allow Same-Day Booking',
                value: state.allowSameDayBooking,
                onChanged: (_) => bloc.add(
                  const ToggleAppointmentRule(AppointmentRule.sameDayBooking),
                ),
              ),
              ToggleRow(
                title: 'Rescheduling Allowed',
                value: state.reschedulingAllowed,
                onChanged: (_) => bloc.add(
                  const ToggleAppointmentRule(
                    AppointmentRule.reschedulingAllowed,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ------------------------- Blocked Slots -------------------------
class _BlockedSlotsCard extends StatelessWidget {
  const _BlockedSlotsCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) => prev.blockedSlots != curr.blockedSlots,
      builder: (context, state) {
        final bloc = context.read<ScheduleSettingBloc>();
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Blocked Slots',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => bloc.add(
                      AddBlockedSlot(
                        BlockedSlot(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: 'New Blocked Slot',
                          subtitle: 'Daily • 12:00 PM - 01:00 PM',
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 16, color: kPurple),
                    label: const Text(
                      'Add New',
                      style: TextStyle(
                        color: kPurple,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final slot in state.blockedSlots)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F6FB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              slot.subtitle,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.deepOrange,
                          size: 20,
                        ),
                        onPressed: () => bloc.add(RemoveBlockedSlot(slot.id)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// ------------------------- Schedule Summary -------------------------
class _ScheduleSummaryCard extends StatelessWidget {
  const _ScheduleSummaryCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) =>
          prev.weekdaySummary != curr.weekdaySummary ||
          prev.saturdaySummary != curr.saturdaySummary ||
          prev.sundayUnavailable != curr.sundayUnavailable,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EEFB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE6DCF7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Schedule Summary',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  color: kPurple,
                ),
              ),
              const SizedBox(height: 12),
              _summaryRow('Mon - Fri', state.weekdaySummary),
              const SizedBox(height: 8),
              _summaryRow('Saturday', state.saturdaySummary),
              const SizedBox(height: 8),
              _summaryRow(
                'Sunday',
                state.sundayUnavailable ? 'Unavailable' : 'Available',
                valueColor: state.sundayUnavailable
                    ? Colors.redAccent
                    : Colors.black87,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: valueColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// ------------------------- Holidays & Leave -------------------------
class _HolidaysCard extends StatelessWidget {
  const _HolidaysCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleSettingBloc, ScheduleState>(
      buildWhen: (prev, curr) =>
          prev.vacationMode != curr.vacationMode ||
          prev.holidays != curr.holidays,
      builder: (context, state) {
        final bloc = context.read<ScheduleSettingBloc>();
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Holidays & Leave',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Text(
                    'Vacation Mode',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: kPurple,
                    ),
                  ),
                  Switch.adaptive(
                    value: state.vacationMode,
                    activeColor: Colors.white,
                    activeTrackColor: kPurple,
                    onChanged: (_) => bloc.add(const ToggleVacationMode()),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final holiday in state.holidays)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F6FB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              holiday.day,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: kPurple,
                              ),
                            ),
                            Text(
                              holiday.month,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 10,
                                fontWeight: FontWeight.w400,

                                color: kPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              holiday.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              holiday.duration,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.black38),
                    ],
                  ),
                ),
              OutlinedButton.icon(
                onPressed: () => bloc.add(
                  AddHoliday(
                    Holiday(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      day: '01',
                      month: 'Jan',
                      title: 'New Holiday',
                      duration: 'Duration: 1 Day',
                    ),
                  ),
                ),
                icon: const Icon(Icons.add, size: 18, color: kPurple),
                label: const Text(
                  'Add Holiday',
                  style: TextStyle(color: kPurple, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46),
                  side: const BorderSide(color: Color(0xFFE3E1EC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
