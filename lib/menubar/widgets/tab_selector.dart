import 'package:flutter/material.dart';
import 'package:medicompare/features/home/presentation/bloc/home_bloc.dart';
import '../theme/app_theme.dart';

class TabSelector extends StatelessWidget {
  final HomeTab selected;
  final ValueChanged<HomeTab> onTap;

  const TabSelector({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _tab(HomeTab.actions, Icons.bolt_rounded, 'Actions'),
        ],
      ),
    );
  }

  Widget _tab(HomeTab tab, IconData icon, String label) {
    final bool isSelected = tab == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryButtonGradient : null,
            borderRadius: BorderRadius.circular(10),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
