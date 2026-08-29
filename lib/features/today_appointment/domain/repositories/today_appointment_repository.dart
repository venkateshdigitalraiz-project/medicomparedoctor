import 'package:medicompare/features/today_appointment/domain/entities/today_appointments_paginated_entity.dart';

abstract class TodayAppointmentRepository {
  Future<TodayAppointmentsPaginatedEntity> getTodayAppointments({
    required int page,
    required int limit,
  });
}
