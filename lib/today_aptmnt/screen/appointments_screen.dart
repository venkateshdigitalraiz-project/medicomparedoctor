import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/today_aptmnt/bloc/appointment_bloc.dart';
import 'package:medicompare/today_aptmnt/screen/appointment_card.dart';
import '../bloc/appointment_event.dart';
import '../bloc/appointment_state.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentBloc()..add(const LoadAppointments()),
      child: const _AppointmentsView(),
    );
  }
}

class _AppointmentsView extends StatelessWidget {
  const _AppointmentsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            Expanded(
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  if (state.status == AppointmentStatusFlag.loading ||
                      state.status == AppointmentStatusFlag.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == AppointmentStatusFlag.failure) {
                    return Center(
                      child: Text(state.errorMessage ?? 'Something went wrong'),
                    );
                  }

                  if (state.visibleAppointments.isEmpty) {
                    return const Center(child: Text('No appointments found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    itemCount: state.visibleAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = state.visibleAppointments[index];
                      return AppointmentCard(
                        appointment: appointment,
                        onMoreTap: (appointment) {
                          //  _showAppointmentMenu(context, appointment);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showAppointmentMenu(
  //   BuildContext context,
  //   Appointment appointment,
  // ) async {
  //   final selected = await showMenu<String>(
  //     context: context,
  //     position: const RelativeRect.fromLTRB(100, 200, 20, 0),
  //     items: const [
  //       PopupMenuItem(value: "details", child: Text("View Details")),
  //       PopupMenuItem(value: "reschedule", child: Text("Reschedule")),
  //       PopupMenuItem(value: "call", child: Text("Call Patient")),
  //       PopupMenuItem(value: "cancel", child: Text("Cancel Appointment")),
  //     ],
  //   );

  //   switch (selected) {
  //     case "details":
  //       print("Username ${appointment.name}");
  //       print(" ID = {appointment.id}");
  //       //Navigator.pushReplacementNamed(context, RouteNames.todayApartmentdtls);
  //       break;

  //     case "reschedule":
  //       print("Reschedule ${appointment.name}");
  //       break;

  //     case "call":
  //       print("Call ${appointment.name}");
  //       break;

  //     case "cancel":
  //       print("Cancel ${appointment.name}");
  //       break;
  //   }
  // }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
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
                  color: Color(0xFF1F1F2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
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
                          onChanged: (value) => context
                              .read<AppointmentBloc>()
                              .add(SearchAppointments(value)),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by name or ID',
                            hintStyle: TextStyle(
                              color: Color(0xFF8A8A9C),
                              fontSize: 14,
                            ),
                            isDense: true,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.searchTodayAppointment,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap:
                    ()
                    // {
                    //   context.read<AppointmentBloc>().add(FilterByDate(null));
                    // },
                    async {
                      final RenderBox button =
                          context.findRenderObject() as RenderBox;
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject()
                              as RenderBox;

                      final selected = await showMenu<String>(
                        context: context,
                        color: Colors.white,
                        elevation: 8,
                        position: RelativeRect.fromRect(
                          Rect.fromPoints(
                            button.localToGlobal(
                              Offset(
                                button.size.width - 20,
                                button.size.height,
                              ),
                              ancestor: overlay,
                            ),
                            button.localToGlobal(
                              button.size.bottomRight(Offset.zero),
                              ancestor: overlay,
                            ),
                          ),
                          Offset.zero & overlay.size,
                        ),
                        items: const [
                          PopupMenuItem(value: "Today", child: Text("Today")),
                          PopupMenuItem(
                            value: "Last week",
                            child: Text("Last week"),
                          ),
                          PopupMenuItem(
                            value: "Last Month",
                            child: Text("Last Month"),
                          ),
                          PopupMenuItem(
                            value: "Last 3 Months",
                            child: Text("Last 3 Months"),
                          ),
                        ],
                      );

                      if (selected != null && context.mounted) {
                        context.read<AppointmentBloc>().add(
                          FilterByDate(selected),
                        );
                      }
                    },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Color(0xFF1F1F2E),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
