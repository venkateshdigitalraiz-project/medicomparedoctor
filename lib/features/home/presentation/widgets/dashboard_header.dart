import 'package:flutter/material.dart';
import 'package:medicompare/core/widget/circle_login_button.dart';
import 'package:medicompare/core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String avatarUrl;
  final VoidCallback? login;
  final VoidCallback? onAvatarTap;

  const DashboardHeader({
    super.key,
    required this.avatarUrl,
    required this.login,
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
                  child: (avatarUrl.startsWith('http://') ||
                          avatarUrl.startsWith('https://'))
                      ? Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print(error);
                            return const Icon(Icons.person, size: 40);
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        )
                      : const Icon(Icons.person, size: 40),
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
        const SizedBox(width: 10),
        // CircleIconButton(icon: Icons.logout, onTap: login),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleIconButton(icon: Icons.logout, onTap: login),
            const SizedBox(height: 4),
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
