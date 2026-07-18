import 'package:flutter/material.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/today_aptmnt/screen/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  //final VoidCallback? onMoreTap;
  final Function(Appointment)? onMoreTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onMoreTap,
    // required void Function() onAction,
  });

  bool get _isConfirmed => appointment.status == AppointmentStatus.confirmed;
  bool get _isOnline => appointment.type == AppointmentType.online;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = _isConfirmed
        ? const Color(0xFF6C4DF6)
        : const Color(0xFFE8873A);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored accent bar
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time column
                    SizedBox(
                      width: 54,
                      child: Text(
                        appointment.time.replaceAll(' ', '\n'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          fontFamily: "Poppins",
                          color: Color(0xFF1F1F2E),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 2),
                    // Avatar
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFEFEFF5),
                      backgroundImage: NetworkImage(appointment.avatarUrl),
                    ),
                    const SizedBox(width: 8),
                    // Name + type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F1F2E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                _isOnline
                                    ? Icons.videocam_rounded
                                    : Icons.access_time_rounded,
                                size: 15,
                                color: _isOnline
                                    ? const Color(0xFFE8873A)
                                    : const Color(0xFF8A8A9C),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isOnline ? 'Online' : 'In-person',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  color: Color(0xFF8A8A9C),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status badge + menu
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _StatusBadge(isConfirmed: _isConfirmed),
                        const SizedBox(height: 18),
                        // InkWell(
                        //   onTap: onMoreTap?.call(appointment),
                        //   borderRadius: BorderRadius.circular(20),
                        //   child: const Padding(
                        //     padding: EdgeInsets.all(4),
                        //     child: Icon(
                        //       Icons.more_vert_rounded,
                        //       size: 20,
                        //       color: Color(0xFF8A8A9C),
                        //     ),
                        //   ),
                        // ),
                        // InkWell(
                        //   onTap: () {
                        //     onMoreTap?.call(appointment);
                        //   },
                        //   borderRadius: BorderRadius.circular(20),
                        //   child: const Padding(
                        //     padding: EdgeInsets.all(4),
                        //     child: Icon(
                        //       Icons.more_vert_rounded,
                        //       size: 20,
                        //       color: Color(0xFF8A8A9C),
                        //     ),
                        //   ),
                        // ),
                        PopupMenuButton<String>(
                          color: Colors.white,
                          elevation: 8,
                          offset: const Offset(-10, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case "details":
                                print("click");
                                print(appointment.name);
                                print(appointment.id);
                                Navigator.pushReplacementNamed(
                                  context,
                                  RouteNames.todayApartmentdtls,
                                  arguments: appointment.id,
                                );

                                break;
                              case "reschedule":
                                print("Reschedule");
                                break;
                              case "call":
                                print("Call");
                                break;
                              case "cancel":
                                print("Cancel");
                                break;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: "details",
                              child: Text("View Details"),
                            ),
                            PopupMenuItem(
                              value: "reschedule",
                              child: Text("Reschedule"),
                            ),
                            PopupMenuItem(
                              value: "call",
                              child: Text("Call Patient"),
                            ),
                            PopupMenuItem(
                              value: "cancel",
                              child: Text("Cancel Appointment"),
                            ),
                          ],
                          child: const Icon(
                            Icons.more_vert_rounded,
                            color: Color(0xFF8A8A9C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isConfirmed;

  const _StatusBadge({required this.isConfirmed});

  @override
  Widget build(BuildContext context) {
    final Color bg = isConfirmed
        ? const Color(0xFFF1EBFF)
        : const Color(0xFFFDECDA);
    final Color fg = isConfirmed
        ? const Color(0xFF6C4DF6)
        : const Color(0xFFE8873A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isConfirmed ? 'Confirmed' : 'Waiting',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: "Poppins",
          color: fg,
        ),
      ),
    );
  }
}
