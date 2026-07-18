import 'package:flutter/material.dart';

enum HolidayType { publicHoliday, professionalLeave, personalLeave, blocked }

class Holiday {
  final String id;
  final String title;
  final DateTime date;
  final HolidayType type;
  final DateTime? endDate;

  Holiday({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.endDate,
  });

  String get typeLabel {
    switch (type) {
      case HolidayType.publicHoliday:
        return 'Public Holiday';
      case HolidayType.professionalLeave:
        return 'Professional Leave';
      case HolidayType.personalLeave:
        return 'Personal Leave';
      case HolidayType.blocked:
        return 'Blocked';
    }
  }

  Color get typeColor {
    switch (type) {
      case HolidayType.publicHoliday:
        return const Color(0xFF6A1B9A);
      case HolidayType.professionalLeave:
        return const Color(0xFFFFA726);
      case HolidayType.personalLeave:
        return const Color(0xFF7B61FF);
      case HolidayType.blocked:
        return const Color(0xFFE53935);
    }
  }

  Color get typeBgColor {
    switch (type) {
      case HolidayType.publicHoliday:
        return const Color(0xFFEDE7F6);
      case HolidayType.professionalLeave:
        return const Color(0xFFFFF3E0);
      case HolidayType.personalLeave:
        return const Color(0xFFEDE7F6);
      case HolidayType.blocked:
        return const Color(0xFFFFEBEE);
    }
  }

  Holiday copyWith({
    String? id,
    String? title,
    DateTime? date,
    HolidayType? type,
    DateTime? endDate,
  }) {
    return Holiday(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      endDate: endDate ?? this.endDate,
    );
  }
}

class ActivityItem {
  final String title;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final String dateRange;

  ActivityItem({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    required this.dateRange,
  });
}

class HolidayCategory {
  final String name;
  HolidayCategory(this.name);
}
