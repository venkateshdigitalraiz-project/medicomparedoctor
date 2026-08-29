import 'package:medicompare/features/today_appointment/domain/entities/today_appointments_paginated_entity.dart';
import 'package:medicompare/features/today_appointment/domain/repositories/today_appointment_repository.dart';

class GetTodayAppointmentsUseCase {
  final TodayAppointmentRepository repository;

  GetTodayAppointmentsUseCase(this.repository);

  Future<TodayAppointmentsPaginatedEntity> call({
    required int page,
    required int limit,
  }) async {
    return await repository.getTodayAppointments(
      page: page,
      limit: limit,
    );
  }
}
