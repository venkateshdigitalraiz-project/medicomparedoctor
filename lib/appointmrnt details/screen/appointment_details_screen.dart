import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/appointmrnt%20details/bloc/appointment_bloc.dart';
import 'package:medicompare/appointmrnt%20details/bloc/appointment_event.dart';
import 'package:medicompare/appointmrnt%20details/bloc/appointment_state.dart';
import 'package:medicompare/appointmrnt%20details/screen/appointment_widgets.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final String appointmentId;

  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AppointmentBloc()..add(LoadAppointmentDetails(appointmentId)),
      child: const _AppointmentDetailsView(),
    );
  }
}

class _AppointmentDetailsView extends StatelessWidget {
  const _AppointmentDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: BlocConsumer<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state is AppointmentLoaded && state.lastActionMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.lastActionMessage!),
                    duration: const Duration(seconds: 2),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state is AppointmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AppointmentError) {
              return Center(child: Text(state.message));
            }
            if (state is AppointmentLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppointmentLoaded state) {
    final appointment = state.appointment;
    final bloc = context.read<AppointmentBloc>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // ---- App bar row ----
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            const Expanded(
              child: Text(
                'Appointment Details',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(appointment.avatarUrl),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ---- Call / Video / Chat buttons ----
        Row(
          children: [
            ContactButton(
              icon: Icons.call,
              label: 'Call',
              color: const Color(0xFF16A34A),
              onTap: () =>
                  bloc.add(const ContactActionPressed(ContactAction.call)),
            ),
            ContactButton(
              icon: Icons.videocam,
              label: 'Video',
              color: const Color(0xFF2563EB),
              onTap: () =>
                  bloc.add(const ContactActionPressed(ContactAction.video)),
            ),
            ContactButton(
              icon: Icons.chat_bubble,
              label: 'Chat',
              color: const Color(0xFF7C3AED),
              onTap: () =>
                  bloc.add(const ContactActionPressed(ContactAction.chat)),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ---- Patient info card ----
        SectionCard(
          child: Column(
            children: [
              InfoRow(label: 'Patient Name', value: appointment.patientName),
              InfoRow(label: 'ID', value: appointment.patientId),
              InfoRow(label: 'Type', value: appointment.type),
              InfoRow(
                label: 'Appointment Time',
                value: appointment.appointmentTime,
                showDivider: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ---- Appointment details card ----
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: Color(0xFF7C3AED),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Appointment Details',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              LabeledValue(
                label: 'Surgery type',
                value: appointment.surgeryType,
              ),
              const SizedBox(height: 14),
              LabeledValue(label: 'Location', value: appointment.location),
              const SizedBox(height: 14),
              LabeledValue(
                label: 'Reason For Checkup',
                value: appointment.reasonForCheckup,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: LabeledValue(
                      label: 'Appointment Type',
                      value: appointment.appointmentType,
                    ),
                  ),
                  Expanded(
                    child: LabeledValue(
                      label: 'Duration',
                      value: appointment.duration,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Clinical Notes',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ...appointment.clinicalNotes.map(
                (note) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6, right: 8),
                        child: Icon(
                          Icons.circle,
                          size: 6,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          note,
                          style: const TextStyle(fontSize: 14, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Appointment Timeline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ...List.generate(appointment.timeline.length, (index) {
                final isLast = index == appointment.timeline.length - 1;
                return TimelineTile(
                  event: appointment.timeline[index],
                  isLast: isLast,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
