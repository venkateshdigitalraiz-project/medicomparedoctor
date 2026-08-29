import 'package:flutter/material.dart';
import 'package:medicompare/features/home/presentation/bloc/home_bloc.dart';
import 'package:medicompare/core/theme/app_theme.dart';

class TabSelector extends StatelessWidget {
  final HomeTab selected;
  final ValueChanged<HomeTab> onTap;

  const TabSelector({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _tab(HomeTab.overview, Icons.grid_view_rounded, 'Overview'),
          _tab(
            HomeTab.appointments,
            Icons.calendar_today_rounded,
            'Appointments',
          ),
        ],
      ),
    );
  }

  Widget _tab(HomeTab tab, IconData icon, String label) {
    final bool isSelected = tab == selected;
    return Expanded(
      child: SizedBox(
        // margin: EdgeInsets.only(right: 8),
        height: 45,
        child: GestureDetector(
          onTap: () => onTap(tab),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            //padding: const EdgeInsets.only(right: 4),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryButtonGradient : null,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,

                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
