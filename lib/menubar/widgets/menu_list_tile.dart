import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';

class MenuListTile extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;
  final bool showDivider;

  const MenuListTile({
    super.key,
    required this.item,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, size: 20, color: item.iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                if (item.showChevron)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textGrey,
                    size: 22,
                  ),
              ],
            ),
            if (showDivider) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.cardBorder),
            ],
          ],
        ),
      ),
    );
  }
}
