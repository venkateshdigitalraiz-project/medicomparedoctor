import 'package:flutter/material.dart';
import '../../data/models/patient_filter.dart';

class FilterTabBar extends StatelessWidget {
  final PatientFilter activeFilter;
  final ValueChanged<PatientFilter> onChanged;

  const FilterTabBar({
    super.key,
    required this.activeFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: PatientFilter.values.map((filter) {
          final isActive = filter == activeFilter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                        )
                      : null,
                  color: isActive ? null : Colors.transparent,

                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: filter == PatientFilter.all
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.grid_view_rounded,
                            size: 14,
                            color: isActive ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            filter.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              color: isActive ? Colors.white : Colors.grey[600],
                            ),
                          ),
                        ],
                      )
                    : Text(
                        filter.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Poppins",
                          color: isActive ? Colors.white : Colors.grey[600],
                        ),
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
