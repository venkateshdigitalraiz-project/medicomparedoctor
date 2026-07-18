import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String avatarUrl;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onAvatarTap;

  const DashboardHeader({
    super.key,
    required this.avatarUrl,
    this.onCalendarTap,
    required this.onAvatarTap,
  });
  Widget _buildLogo() {
    return Image.asset(
      "assets/images/applogo.png",
      width: 106,
      height: 42,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildLogo(),
        const Spacer(),
        _CircleIconButton(
          icon: Icons.calendar_today_outlined,
          onTap: onCalendarTap,
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onAvatarTap,
          child: Stack(
            children: [
              // CircleAvatar(
              //   radius: 21,
              //   backgroundColor:const Color(0xFFE5E7EB),
              //   child: CircleAvatar(
              //     radius: 19,
              //     backgroundImage: NetworkImage(avatarUrl),
              //   ),
              // ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF601CA3), width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print(error);
                      return const Icon(Icons.person, size: 40);
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
