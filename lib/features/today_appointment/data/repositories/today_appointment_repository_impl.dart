import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/features/today_appointment/data/datasources/today_appointment_remote_data_source.dart';
import 'package:medicompare/features/today_appointment/domain/entities/today_appointments_paginated_entity.dart';
import 'package:medicompare/features/today_appointment/domain/repositories/today_appointment_repository.dart';

class TodayAppointmentRepositoryImpl implements TodayAppointmentRepository {
  final TodayAppointmentRemoteDataSource remoteDataSource;

  TodayAppointmentRepositoryImpl({
    TodayAppointmentRemoteDataSource? remoteDataSource,
  }) : remoteDataSource =
            remoteDataSource ?? TodayAppointmentRemoteDataSourceImpl();

  @override
  Future<TodayAppointmentsPaginatedEntity> getTodayAppointments({
    required int page,
    required int limit,
  }) async {
    try {
      return await remoteDataSource.getTodayAppointments(
        page: page,
        limit: limit,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch today appointments: $e');
    }
  }
}
