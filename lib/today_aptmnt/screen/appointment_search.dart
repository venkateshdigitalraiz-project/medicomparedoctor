import 'package:flutter/material.dart';

/// Model representing a single appointment entry in the list.
class Appointment {
  final String name;
  final String avatarUrl;

  const Appointment({required this.name, required this.avatarUrl});
}

/// Replicates the "Today's Appointments" search screen:
/// - Light blue header with back arrow + title
/// - Search field with a leading search icon and a trailing calendar button
/// - A scrollable list of appointments, each with an avatar, name,
///   and a close (X) button to remove the entry.
class AppointmentSearch extends StatefulWidget {
  const AppointmentSearch({super.key});

  @override
  State<AppointmentSearch> createState() => _AppointmentSearchState();
}

class _AppointmentSearchState extends State<AppointmentSearch> {
  final TextEditingController _searchController = TextEditingController();

  // Sample data — replace avatarUrl with your own asset/network paths.
  final List<Appointment> _appointments = [
    const Appointment(
      name: 'Robert Fox',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    const Appointment(
      name: 'Fathima',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
    ),
    const Appointment(
      name: 'Lakshmi',
      avatarUrl: 'https://i.pravatar.cc/150?img=45',
    ),
  ];

  List<Appointment> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    _filteredAppointments = List.from(_appointments);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAppointments = _appointments
          .where((a) => a.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _removeAppointment(Appointment appointment) {
    setState(() {
      _appointments.remove(appointment);
      _filteredAppointments.remove(appointment);
    });
  }

  void _openDatePicker() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color headerBlue = Color(0xFFEAF2FE);
    const Color borderGrey = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ----- Header -----
            Container(
              color: headerBlue,
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 24),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Today's Appointments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // ----- Search bar + calendar button -----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderGrey),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black45,
                          ),
                          hintText: 'Search by name, phone, or ID',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderGrey),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black87,
                        size: 20,
                      ),
                      onPressed: _openDatePicker,
                    ),
                  ),
                ],
              ),
            ),

            // ----- Appointment list -----
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filteredAppointments.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFFF0F0F0),
                ),
                itemBuilder: (context, index) {
                  final appointment = _filteredAppointments[index];
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(appointment.avatarUrl),
                    ),
                    title: Text(
                      appointment.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 20,
                      ),
                      onPressed: () => _removeAppointment(appointment),
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
