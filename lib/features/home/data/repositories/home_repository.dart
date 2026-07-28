import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import '../models/appointment.dart';
import '../models/clinic_status.dart';
import '../models/dashboard_response.dart';

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
  final http.Client client;
  final String baseUrl;

  HomeRepositoryImpl({
    http.Client? client,
    this.baseUrl = AppConstants.baseUrl,
  }) : client = client ?? http.Client();

  @override
  Future<DashboardResponse> fetchDashboard({
    required int page,
    required int limit,
  }) async {
    final token = await SessionManager.getToken();
    final uri = Uri.parse(
      '$baseUrl${AppConstants.dashboardEndpoint}?page=$page&limit=$limit',
    );

    developer.log('=== DASHBOARD API REQUEST ===', name: 'HomeRepository');
    developer.log('URL: $uri', name: 'HomeRepository');

    try {
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(AppConstants.apiTimeout);

      developer.log('Status: ${response.statusCode}', name: 'HomeRepository');
      developer.log('Body: ${response.body}', name: 'HomeRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return DashboardResponse.fromJson(json);
      } else {
        throw Exception(
          'Dashboard fetch failed. Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      developer.log(
        'SocketException — returning empty mock dashboard',
        name: 'HomeRepository',
      );
      return _emptyMock();
    } on http.ClientException {
      developer.log(
        'ClientException — returning empty mock dashboard',
        name: 'HomeRepository',
      );
      return _emptyMock();
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
