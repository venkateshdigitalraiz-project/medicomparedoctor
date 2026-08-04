import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import '../../domain/repositories/patients_repository.dart';
import '../models/patient.dart';

import 'package:medicompare/core/network/global_client.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final http.Client client;
  final String baseUrl;

  PatientsRepositoryImpl({
    http.Client? client,
    this.baseUrl = AppConstants.baseUrl,
  }) : client = client ?? AppHttpClient.client;

  @override
  Future<PatientListResponse> fetchPatients({
    required int page,
    required int limit,
  }) async {
    final token = await SessionManager.getToken();
    final uri = Uri.parse(
      '$baseUrl/doctor/dashboard/patient-list?page=$page&limit=$limit',
    );

    developer.log('=== PATIENT LIST API REQUEST ===', name: 'PatientsRepository');
    developer.log('URL: $uri', name: 'PatientsRepository');

    try {
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(AppConstants.apiTimeout);

      developer.log('Status: ${response.statusCode}', name: 'PatientsRepository');
      developer.log('Body: ${response.body}', name: 'PatientsRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return PatientListResponse.fromJson(json);
      } else {
        throw Exception(
          'Failed to fetch patient list. Status: ${response.statusCode}',
        );
      }
    } on SocketException {
      developer.log(
        'SocketException — returning empty mock list response',
        name: 'PatientsRepository',
      );
      return _emptyMock();
    } on http.ClientException {
      developer.log(
        'ClientException — returning empty mock list response',
        name: 'PatientsRepository',
      );
      return _emptyMock();
    }
  }

  PatientListResponse _emptyMock() {
    return const PatientListResponse(
      statistics: PatientStatistics(
        totalPatients: 0,
        newThisMonth: 0,
        waiting: 0,
        completed: 0,
        cancelled: 0,
      ),
      pagination: PatientPagination(
        page: 1,
        limit: 10,
        total: 0,
        totalPages: 0,
      ),
      patients: <Patient>[],
    );
  }
}
