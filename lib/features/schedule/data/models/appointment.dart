import 'package:equatable/equatable.dart';

enum AppointmentStatus { confirmed, waiting, cancelled }

extension AppointmentStatusX on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.waiting:
        return 'Waiting';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum AppointmentMode { inPerson, online, linkExpired }

class Appointment extends Equatable {
  final String id;
  final String patientName;
  final String avatarUrl;
  final String time;
  final AppointmentMode mode;
  final AppointmentStatus status;
  final String? meetingLink;
  // New properties from requirement #4
  final int age;
  final String phone;
  final String city;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.avatarUrl,
    required this.time,
    required this.mode,
    required this.status,
    this.meetingLink,
    required this.age,
    required this.phone,
    required this.city,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    AppointmentStatus status;
    switch ((json['status'] as String? ?? '').toLowerCase()) {
      case 'confirmed':
        status = AppointmentStatus.confirmed;
        break;
      case 'cancelled':
        status = AppointmentStatus.cancelled;
        break;
      default:
        status = AppointmentStatus.waiting;
    }

    AppointmentMode mode;
    final modeStr = (json['mode'] as String? ?? '').toLowerCase();
    if (modeStr == 'online') {
      mode = AppointmentMode.online;
    } else if (modeStr == 'linkexpired') {
      mode = AppointmentMode.linkExpired;
    } else {
      mode = AppointmentMode.inPerson;
    }

    // Safely parse age
    final rawAge = json['age'];
    int ageVal = 0;
    if (rawAge is int) {
      ageVal = rawAge;
    } else if (rawAge is String) {
      ageVal = int.tryParse(rawAge) ?? 0;
    }

    return Appointment(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? json['name']?.toString() ?? 'Unknown',
      avatarUrl: json['avatarUrl']?.toString() ?? json['profileImage']?.toString() ?? '',
      time: json['preferredTime']?.toString() ?? json['time']?.toString() ?? '',
      mode: mode,
      status: status,
      meetingLink: json['meetingLink']?.toString(),
      age: ageVal,
      phone: json['phone']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
    );
  }

  bool get isCancelled => status == AppointmentStatus.cancelled;

  @override
  List<Object?> get props =>
      [id, patientName, avatarUrl, time, mode, status, meetingLink, age, phone, city];
}

class ScheduleStats extends Equatable {
  final int total;
  final int confirmed;
  final int waiting;
  final int cancelled;

  const ScheduleStats({
    required this.total,
    required this.confirmed,
    required this.waiting,
    required this.cancelled,
  });

  factory ScheduleStats.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return ScheduleStats(
      total: parseInt(json['totalAppointments']),
      confirmed: parseInt(json['confirmed']),
      waiting: parseInt(json['waiting']),
      cancelled: parseInt(json['cancelled']),
    );
  }

  @override
  List<Object?> get props => [total, confirmed, waiting, cancelled];
}

class CalendarDay extends Equatable {
  final String dayName;
  final int date;
  final int count;
  final String dateString; // to know the exact date in format YYYY-MM-DD or similar

  const CalendarDay({
    required this.dayName,
    required this.date,
    required this.count,
    required this.dateString,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    final rawDate = json['date'];
    int parsedDate = parseInt(rawDate);
    if (parsedDate == 0 && rawDate is String) {
      // If it is a string like "2026-07-28", parse the last part (day)
      try {
        final parsedDt = DateTime.parse(rawDate);
        parsedDate = parsedDt.day;
      } catch (_) {}
    }

    return CalendarDay(
      dayName: json['dayName']?.toString() ?? '',
      date: parsedDate,
      count: parseInt(json['count']),
      dateString: json['dateString']?.toString() ?? json['date']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [dayName, date, count, dateString];
}

class ScheduleAppointmentsPage extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final List<Appointment> list;

  const ScheduleAppointmentsPage({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.list,
  });

  factory ScheduleAppointmentsPage.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    final rawList = json['list'] as List<dynamic>? ?? [];
    return ScheduleAppointmentsPage(
      total: parseInt(json['total']),
      page: parseInt(json['page']) != 0 ? parseInt(json['page']) : 1,
      limit: parseInt(json['limit']) != 0 ? parseInt(json['limit']) : 10,
      totalPages: parseInt(json['totalPages']),
      list: rawList
          .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [total, page, limit, totalPages, list];
}

class ScheduleResponse extends Equatable {
  final ScheduleStats summary;
  final List<CalendarDay> calendar;
  final ScheduleAppointmentsPage appointments;

  const ScheduleResponse({
    required this.summary,
    required this.calendar,
    required this.appointments,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawCalendar = data['calendar'] as List<dynamic>? ?? [];
    return ScheduleResponse(
      summary: ScheduleStats.fromJson(data['summary'] as Map<String, dynamic>? ?? {}),
      calendar: rawCalendar.map((e) => CalendarDay.fromJson(e as Map<String, dynamic>)).toList(),
      appointments: ScheduleAppointmentsPage.fromJson(data['appointments'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  List<Object?> get props => [summary, calendar, appointments];
}
