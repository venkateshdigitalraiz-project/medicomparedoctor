import 'package:flutter/material.dart';

/// Profile Screen - StatelessWidget implementation
/// Matches the design: header with avatar, stats row, expandable
/// info sections, and bottom nav bar.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryPurple = Color(0xFF5B2C91);
  static const Color bgLight = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _HeaderSection(),
                    const SizedBox(height: 16),
                    const _StatsRow(),
                    const SizedBox(height: 24),
                    const _InfoSection(
                      icon: Icons.person,
                      title: 'Personal Information',
                      expanded: true,
                    ),
                    const _InfoSection(
                      icon: Icons.badge,
                      title: 'Professional Information',
                      expanded: true,
                    ),
                    const _InfoSection(
                      icon: Icons.access_time,
                      title: 'Working Hours',
                      expanded: true,
                      trailingBadge: _Badge(
                        text: 'Available Now',
                        color: Color(0xFFDFF7E8),
                        textColor: Color(0xFF1FA35A),
                      ),
                    ),
                    const _InfoSection(
                      icon: Icons.apartment,
                      title: 'Clinic Information',
                      expanded: true,
                    ),
                    const _InfoSection(
                      icon: Icons.shield_outlined,
                      title: 'Documents',
                      expanded: true,
                      trailingBadge: _Badge(
                        text: 'Verified',
                        color: Color(0xFFDFF7E8),
                        textColor: Color(0xFF1FA35A),
                        showCheck: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

/// Top header: back button, title, edit icon, avatar, name, role, id.
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: ProfileScreen.bgLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoundIconButton(icon: Icons.arrow_back, onTap: () {}),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              //   _RoundIconButton(icon: Icons.edit_outlined, onTap: () {}),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=200',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Dr. Sarah Johnson',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 6),
              CircleAvatar(
                radius: 9,
                backgroundColor: Color(0xFF2E9E5B),
                child: Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Cardiologist',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.circle, size: 4, color: Colors.black38),
              ),
              Text(
                'ID: 156456456656',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}

/// Row of three stat cards (Total Patients, Total Appt, Completed).
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          Expanded(
            child: _StatCard(
              icon: Icons.groups,
              iconBg: Color(0xFFE3EEFF),
              iconColor: Color(0xFF4A7EF0),
              value: '1.2k',
              label: 'Total Patients',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.event_available,
              iconBg: Color(0xFFFFE8D9),
              iconColor: Color(0xFFF08A3C),
              value: '900',
              label: 'Total Appt',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.check_circle,
              iconBg: Color(0xFFDDF7E6),
              iconColor: Color(0xFF2E9E5B),
              value: '850',
              label: 'Completed',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProfileScreen.primaryPurple, width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

/// Expandable info row (Personal Information, Working Hours, etc.)
/// Static/stateless version — pass `expanded` to control the chevron
/// direction; wire up real expand/collapse logic in a parent
/// StatefulWidget or with a state-management solution if needed.
class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool expanded;
  final Widget? trailingBadge;

  const _InfoSection({
    required this.icon,
    required this.title,
    this.expanded = false,
    this.trailingBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (trailingBadge != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 8),
                child: trailingBadge!,
              ),
            )
          else
            const SizedBox(height: 14),
          Row(
            children: [
              Icon(icon, size: 22, color: ProfileScreen.primaryPurple),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.black54,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final bool showCheck;

  const _Badge({
    required this.text,
    required this.color,
    required this.textColor,
    this.showCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCheck) ...[
            Icon(Icons.check_circle, size: 14, color: textColor),
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation bar (Home, Schedule, Patients, Profile).
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _NavItem(icon: Icons.home_outlined, label: 'Home', active: false),
          _NavItem(
            icon: Icons.calendar_today_outlined,
            label: 'Schedule',
            active: false,
          ),
          _NavItem(
            icon: Icons.people_alt_outlined,
            label: 'Patients',
            active: false,
          ),
          _NavItem(icon: Icons.person, label: 'Profile', active: true),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? ProfileScreen.primaryPurple : Colors.black45;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
