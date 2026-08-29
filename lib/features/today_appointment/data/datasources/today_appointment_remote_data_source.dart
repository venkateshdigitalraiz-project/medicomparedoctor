import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/network/global_client.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/features/today_appointment/data/models/today_appointments_response_model.dart';

abstract class TodayAppointmentRemoteDataSource {
  Future<TodayAppointmentsResponseModel> getTodayAppointments({
    required int page,
    required int limit,
  });
}

class TodayAppointmentRemoteDataSourceImpl
    implements TodayAppointmentRemoteDataSource {
  final Dio client;
  final String baseUrl;

  TodayAppointmentRemoteDataSourceImpl({
    Dio? client,
    this.baseUrl = AppConstants.baseUrl,
  }) : client = client ?? AppHttpClient.dio;

  @override
  Future<TodayAppointmentsResponseModel> getTodayAppointments({
    required int page,
    required int limit,
  }) async {
    final token = await SessionManager.getToken();
    final uriStr =
        '$baseUrl${AppConstants.todayAppointmentsEndpoint}?page=$page&limit=$limit';

    developer.log(
      '=== TODAY APPOINTMENTS API REQUEST ===',
      name: 'TodayAppointmentRDS',
    );
    developer.log('URL: $uriStr', name: 'TodayAppointmentRDS');

    try {
      final response = await client.get(
        uriStr,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      developer.log(
        'Status: ${response.statusCode}',
        name: 'TodayAppointmentRDS',
      );
      developer.log('Body: ${response.data}', name: 'TodayAppointmentRDS');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json;
        if (response.data is String) {
          json = jsonDecode(response.data) as Map<String, dynamic>;
        } else {
          json = response.data as Map<String, dynamic>;
        }
        return TodayAppointmentsResponseModel.fromJson(json);
      } else {
        throw Exception(
          'Failed to fetch today\'s appointments. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      developer.log(
        'DioException in TodayAppointmentRDS: $e',
        name: 'TodayAppointmentRDS',
      );
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
    }
  }
}
