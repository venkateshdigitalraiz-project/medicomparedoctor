import 'package:flutter/material.dart';

import '../bloc/consultation_bloc.dart';

class FilterTabs extends StatelessWidget {
  final ConsultationFilter selected;
  final ValueChanged<ConsultationFilter> onSelected;

  const FilterTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _tabs = [
    (ConsultationFilter.all, 'All'),
    (ConsultationFilter.today, 'Today'),
    (ConsultationFilter.videoCall, 'Video Call'),
    (ConsultationFilter.audioCall, 'Audio Call'),
    (ConsultationFilter.inClinic, 'In-clinic'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (filter, label) = _tabs[index];
          final isSelected = filter == selected;

          return GestureDetector(
            onTap: () => onSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF6D28D9), // Start color (X)
                          Color(0xFF8B5CF6), // End color (Y)
                        ],
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  color: isSelected ? Colors.white : Color(0xFF7E8288),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
