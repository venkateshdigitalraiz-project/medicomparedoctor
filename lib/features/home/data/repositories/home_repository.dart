import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/network/network_exception.dart';
import '../models/appointment.dart';
import '../models/clinic_status.dart';
import '../models/dashboard_response.dart';
import 'package:medicompare/core/network/global_client.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------
abstract class HomeRepository {
  Future<DashboardResponse> fetchDashboard({
    required int page,
    required int limit,
  });
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------
class HomeRepositoryImpl implements HomeRepository {
  final Dio client;
  final String baseUrl;

  HomeRepositoryImpl({Dio? client, this.baseUrl = AppConstants.baseUrl})
    : client = client ?? AppHttpClient.dio;

  @override
  Future<DashboardResponse> fetchDashboard({
    required int page,
    required int limit,
  }) async {
    final token = await SessionManager.getToken();
    final uriStr = '$baseUrl${AppConstants.dashboardEndpoint}?page=$page&limit=$limit';

    developer.log('=== DASHBOARD API REQUEST ===', name: 'HomeRepository');
    developer.log('URL: $uriStr', name: 'HomeRepository');

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

      developer.log('Status: ${response.statusCode}', name: 'HomeRepository');
      developer.log('Body: ${response.data}', name: 'HomeRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json;
        if (response.data is String) {
          json = jsonDecode(response.data) as Map<String, dynamic>;
        } else {
          json = response.data as Map<String, dynamic>;
        }
        return DashboardResponse.fromJson(json);
      } else {
        throw Exception(
          'Dashboard fetch failed. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      developer.log(
        'DioException — propagating error',
        name: 'HomeRepository',
      );
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
    }
  }

  DashboardResponse _emptyMock() {
    return DashboardResponse(
      counts: const OverviewStats(
        totalAppointments: 0,
        completedVisits: 0,
        upcomingConsults: 0,
        cancelled: 0,
      ),
      todayAppointments: const AppointmentPage(
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 0,
        list: <Appointment>[],
      ),
    );
  }
}
