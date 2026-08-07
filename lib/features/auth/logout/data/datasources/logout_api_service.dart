import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/network/network_exception.dart';

abstract class LogoutApiService {
  Future<void> logout();
}

class LogoutApiServiceImpl implements LogoutApiService {
  final Dio client;
  final String baseUrl;

  LogoutApiServiceImpl({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  @override
  Future<void> logout() async {
    final urlStr = '$baseUrl${AppConstants.logoutEndpoint}';
    final token = await SessionManager.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    developer.log('=== LOGOUT API REQUEST START ===', name: 'LogoutApiService');
    developer.log('URL: $urlStr', name: 'LogoutApiService');
    developer.log('Headers: $headers', name: 'LogoutApiService');

    try {
      final response = await client.post(
        urlStr,
        options: Options(headers: headers),
      );

      developer.log(
        '=== LOGOUT API RESPONSE ===',
        name: 'LogoutApiService',
      );
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'LogoutApiService',
      );
      developer.log(
        'Response Body: ${response.data}',
        name: 'LogoutApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData = jsonDecode(response.data);
        } else {
          responseData = response.data as Map<String, dynamic>;
        }
        if (responseData['success'] == true) {
          return;
        } else {
          throw Exception(responseData['message'] ?? 'Logout failed');
        }
      } else {
        String errorMsg = 'Failed to logout';
        try {
          final Map<String, dynamic> responseData;
          if (response.data is String) {
            responseData = jsonDecode(response.data);
          } else {
            responseData = response.data as Map<String, dynamic>;
          }
          errorMsg = responseData['message'] ?? errorMsg;
        } catch (_) {}
        throw Exception('$errorMsg (Status code: ${response.statusCode})');
      }
    } on DioException catch (e) {
      developer.log(
        'Error during logout API execution',
        name: 'LogoutApiService',
        error: e,
      );
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
    }
  }
}
