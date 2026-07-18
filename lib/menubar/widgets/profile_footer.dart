import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileFooter extends StatelessWidget {
  final VoidCallback? onAboutTap;
  final VoidCallback? onContactTap;
  final String version;

  const ProfileFooter({
    super.key,
    this.onAboutTap,
    this.onContactTap,
    this.version = 'Version 1.0.0',
  });

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.textDark,
      decoration: TextDecoration.underline,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onAboutTap,
            child: const Text('About Us', style: linkStyle),
          ),
          const _Dot(),
          Text(
            version,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const _Dot(),
          GestureDetector(
            onTap: onContactTap,
            child: const Text('Contact Us', style: linkStyle),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('|', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
    );
  }
}
