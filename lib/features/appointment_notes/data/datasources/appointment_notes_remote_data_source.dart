import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/network/global_client.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/services/session_manager.dart';

abstract class AppointmentNotesRemoteDataSource {
  Future<bool> saveNotes({
    required String appointmentId,
    required String notes,
  });
}

class AppointmentNotesRemoteDataSourceImpl
    implements AppointmentNotesRemoteDataSource {
  final Dio client;
  final String baseUrl;

  AppointmentNotesRemoteDataSourceImpl({
    Dio? client,
    this.baseUrl = AppConstants.baseUrl,
  }) : client = client ?? AppHttpClient.dio;

  @override
  Future<bool> saveNotes({
    required String appointmentId,
    required String notes,
  }) async {
    final token = await SessionManager.getToken();
    final cleanId = appointmentId.trim();
    final uriStr = '$baseUrl/doctor/dashboard/appointment/$cleanId/notes';

    developer.log(
      '=== SAVE APPOINTMENT NOTES API REQUEST ===',
      name: 'AppointmentNotesRDS',
    );
    developer.log('URL: $uriStr', name: 'AppointmentNotesRDS');
    developer.log('Payload: {"notes": "$notes"}', name: 'AppointmentNotesRDS');

    try {
      final response = await client.post(
        uriStr,
        data: jsonEncode({'notes': notes}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      developer.log(
        'Status: ${response.statusCode}',
        name: 'AppointmentNotesRDS',
      );
      developer.log('Body: ${response.data}', name: 'AppointmentNotesRDS');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
          'Failed to save notes. Server responded with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      developer.log(
        'DioException in AppointmentNotesRDS: $e',
        name: 'AppointmentNotesRDS',
      );
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          throw Exception(data['message'].toString());
        }
      }
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
    }
  }
}
