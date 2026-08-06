import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/searchAppointment/bloc/appointment_today_search_bloc.dart';
import 'package:medicompare/searchAppointment/model/appointment_model.dart';

import '../bloc/appointment_today_search_event.dart';
import '../bloc/appointment_today_search_state.dart';

/// Public entry point: wraps the screen with its BLoC provider.
class AppointmentTodaySearchPage extends StatelessWidget {
  const AppointmentTodaySearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AppointmentTodaySearchBloc()
            ..add(const AppointmentTodaySearchStarted()),
      child: const AppointmentTodaySearchScreen(),
    );
  }
}

class AppointmentTodaySearchScreen extends StatefulWidget {
  const AppointmentTodaySearchScreen({super.key});

  @override
  State<AppointmentTodaySearchScreen> createState() =>
      _AppointmentTodaySearchScreenState();
}

class _AppointmentTodaySearchScreenState
    extends State<AppointmentTodaySearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const Color _headerBlue = Color(0xFFEFF6FF);
  static const Color _borderGrey = Color(0xFFE2E2E2);
  static const Color _iconGrey = Color(0xFF4A4A4A);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildSearchRow(context),
            const SizedBox(height: 8),
            Expanded(child: _buildList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _headerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          const Text(
            "Today's Appointments",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    final bloc = context.read<AppointmentTodaySearchBloc>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _borderGrey),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) =>
                    bloc.add(AppointmentTodaySearchQueryChanged(value)),
                decoration: const InputDecoration(
                  hintText: 'Search by name, phone, or ID',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF1F2937),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _buildCalendarButton(bloc),
        ],
      ),
    );
  }

  Widget _buildCalendarButton(AppointmentTodaySearchBloc bloc) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => bloc.add(const AppointmentTodaySearchCalendarTapped()),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderGrey),
        ),
        child: const Icon(Icons.calendar_today_outlined, color: _iconGrey),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return BlocBuilder<AppointmentTodaySearchBloc, AppointmentTodaySearchState>(
      builder: (context, state) {
        if (state.status == AppointmentTodaySearchStatus.loading ||
            state.status == AppointmentTodaySearchStatus.initial) {
          return Center(
            child: AppLoader(
              color: const Color(0xFF6D28D9),
              size: 40,
            ),
          );
        }

        if (state.status == AppointmentTodaySearchStatus.failure) {
          return Center(
            child: Text(state.errorMessage ?? 'Something went wrong'),
          );
        }

        if (state.filteredAppointments.isEmpty) {
          return const Center(
            child: Text(
              'No appointments found',
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.filteredAppointments.length,
          itemBuilder: (context, index) {
            final appointment = state.filteredAppointments[index];
            return _AppointmentRow(
              appointment: appointment,
              onRemove: () => context.read<AppointmentTodaySearchBloc>().add(
                AppointmentTodaySearchAppointmentRemoved(appointment.id),
              ),
            );
          },
        );
      },
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onRemove;

  const _AppointmentRow({required this.appointment, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: NetworkImage(appointment.avatarUrl),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              appointment.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2B2B2B),
              ),
            ),
          ),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.close, color: Colors.black54, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
