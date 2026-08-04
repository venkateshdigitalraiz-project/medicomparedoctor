import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import '../models/appointment.dart';
import 'package:medicompare/core/network/global_client.dart';

abstract class ScheduleRepository {
  Future<ScheduleResponse> fetchSchedule({
    required int page,
    required int limit,
    String? date,
  });
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final http.Client client;
  final String baseUrl;

  ScheduleRepositoryImpl({
    http.Client? client,
    this.baseUrl = AppConstants.baseUrl,
  }) : client = client ?? AppHttpClient.client;

  @override
  Future<ScheduleResponse> fetchSchedule({
    required int page,
    required int limit,
    String? date,
  }) async {
    final token = await SessionManager.getToken();
    var urlStr =
        '$baseUrl${AppConstants.scheduleEndpoint}?page=$page&limit=$limit';
    if (date != null && date.isNotEmpty) {
      urlStr += '&date=$date';
    }
    final uri = Uri.parse(urlStr);

    developer.log('=== SCHEDULE API REQUEST ===', name: 'ScheduleRepository');
    developer.log('URL: $uri', name: 'ScheduleRepository');

    try {
      final response = await client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(AppConstants.apiTimeout);

      developer.log(
        'Status: ${response.statusCode}',
        name: 'ScheduleRepository',
      );
      developer.log('Body: ${response.body}', name: 'ScheduleRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ScheduleResponse.fromJson(json);
      } else {
        throw Exception(
          'Schedule fetch failed. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      developer.log('Error fetching schedule: $e', name: 'ScheduleRepository');
      rethrow;
    }
  }
}
