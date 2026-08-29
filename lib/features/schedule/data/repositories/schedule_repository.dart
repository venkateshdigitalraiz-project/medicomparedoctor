import 'package:medicompare/features/schedule/domain/repositories/schedule_repository.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/features/schedule/data/models/appointment.dart';
import 'package:medicompare/core/network/global_client.dart';



class ScheduleRepositoryImpl implements ScheduleRepository {
  final Dio client;
  final String baseUrl;

  ScheduleRepositoryImpl({
    Dio? client,
    this.baseUrl = AppConstants.baseUrl,
  }) : client = client ?? AppHttpClient.dio;

  @override
  Future<ScheduleResponse> fetchSchedule({
    required int page,
    required int limit,
    String? date,
    String? month,
    String? loadingType,
  }) async {
    final token = await SessionManager.getToken();

    final now = DateTime.now();
    String computedMonth = month ?? '${now.year}-${now.month.toString().padLeft(2, '0')}';
    String? dayOnly;

    if (date != null && date.isNotEmpty) {
      if (date.contains('-')) {
        final parts = date.split('-');
        if (parts.length == 3) {
          computedMonth = '${parts[0]}-${parts[1]}';
          dayOnly = int.tryParse(parts[2])?.toString() ?? parts[2];
        } else {
          dayOnly = date;
        }
      } else {
        dayOnly = date;
      }
    }

    final computedLoadingType =
        loadingType ?? (page == 1 ? 'initial' : 'pagination');

    var urlStr =
        '$baseUrl${AppConstants.scheduleEndpoint}?month=$computedMonth';

    if (dayOnly != null && dayOnly.isNotEmpty) {
      urlStr += '&date=$dayOnly';
    }

    urlStr += '&loadingType=$computedLoadingType&page=$page&limit=$limit';

    developer.log('=== SCHEDULE API REQUEST ===', name: 'ScheduleRepository');
    developer.log('URL: $urlStr', name: 'ScheduleRepository');

    try {
      final response = await client.get(
        urlStr,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      developer.log(
        'Status: ${response.statusCode}',
        name: 'ScheduleRepository',
      );
      developer.log('Body: ${response.data}', name: 'ScheduleRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json;
        if (response.data is String) {
          json = jsonDecode(response.data) as Map<String, dynamic>;
        } else {
          json = response.data as Map<String, dynamic>;
        }
        return ScheduleResponse.fromJson(json);
      } else {
        throw Exception(
          'Schedule fetch failed. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      developer.log('Error fetching schedule: $e', name: 'ScheduleRepository');
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
    }
  }
}
