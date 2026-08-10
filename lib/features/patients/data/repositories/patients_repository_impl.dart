import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/features/patients/domain/repositories/patients_repository.dart';
import 'package:medicompare/features/patients/data/models/patient.dart';
import 'package:medicompare/core/network/global_client.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final Dio client;
  final String baseUrl;

  PatientsRepositoryImpl({
    Dio? client,
    this.baseUrl = AppConstants.baseUrl,
  }) : client = client ?? AppHttpClient.dio;

  @override
  Future<PatientListResponse> fetchPatients({
    required int page,
    required int limit,
  }) async {
    final token = await SessionManager.getToken();
    final uriStr = '$baseUrl${AppConstants.patientsEndpoint}?page=$page&limit=$limit';

    developer.log('=== PATIENT LIST API REQUEST ===', name: 'PatientsRepository');
    developer.log('URL: $uriStr', name: 'PatientsRepository');

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

      developer.log('Status: ${response.statusCode}', name: 'PatientsRepository');
      developer.log('Body: ${response.data}', name: 'PatientsRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json;
        if (response.data is String) {
          json = jsonDecode(response.data) as Map<String, dynamic>;
        } else {
          json = response.data as Map<String, dynamic>;
        }
        return PatientListResponse.fromJson(json);
      } else {
        throw Exception(
          'Failed to fetch patient list. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.error is NetworkException) {
        developer.log(
          'Dio connection error — returning empty mock list response',
          name: 'PatientsRepository',
        );
        return _emptyMock();
      }
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
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
