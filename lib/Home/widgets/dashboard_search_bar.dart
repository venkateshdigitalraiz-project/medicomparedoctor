import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const DashboardSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.body,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
          hintText: 'Search by name, phone, or ID',

          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            color: Colors.black,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
