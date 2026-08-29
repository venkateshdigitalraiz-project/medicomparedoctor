import 'package:medicompare/features/today_appointment/data/models/today_appointment_model.dart';
import 'package:medicompare/features/today_appointment/domain/entities/today_appointments_paginated_entity.dart';

class TodayAppointmentsResponseModel extends TodayAppointmentsPaginatedEntity {
  const TodayAppointmentsResponseModel({
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
    required super.list,
  });

  factory TodayAppointmentsResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic dataObj = json['data'] ?? json;

    if (dataObj is Map<String, dynamic>) {
      final rawList = dataObj['list'] as List<dynamic>? ?? [];
      final appointments = rawList
          .map((item) =>
              TodayAppointmentModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return TodayAppointmentsResponseModel(
        total: (dataObj['total'] as num?)?.toInt() ?? appointments.length,
        page: (dataObj['page'] as num?)?.toInt() ?? 1,
        limit: (dataObj['limit'] as num?)?.toInt() ?? 10,
        totalPages: (dataObj['totalPages'] as num?)?.toInt() ??
            (appointments.isNotEmpty ? 1 : 0),
        list: appointments,
      );
    } else if (dataObj is List) {
      final appointments = dataObj
          .map((item) =>
              TodayAppointmentModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return TodayAppointmentsResponseModel(
        total: appointments.length,
        page: 1,
        limit: appointments.length,
        totalPages: 1,
        list: appointments,
      );
    }

    return const TodayAppointmentsResponseModel(
      total: 0,
      page: 1,
      limit: 10,
      totalPages: 0,
      list: [],
    );
  }
}
