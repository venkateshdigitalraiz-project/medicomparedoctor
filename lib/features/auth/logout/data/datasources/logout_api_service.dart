import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';

abstract class LogoutApiService {
  Future<void> logout();
}

class LogoutApiServiceImpl implements LogoutApiService {
  final http.Client client;
  final String baseUrl;

  LogoutApiServiceImpl({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  @override
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/doctor/profile/logout');
    final token = await SessionManager.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    developer.log('=== LOGOUT API REQUEST START ===', name: 'LogoutApiService');
    developer.log('URL: $url', name: 'LogoutApiService');
    developer.log('Headers: $headers', name: 'LogoutApiService');

    try {
      final response = await client
          .post(url, headers: headers)
          .timeout(AppConstants.apiTimeout);

      developer.log(
        '=== LOGOUT API RESPONSE ===',
        name: 'LogoutApiService',
      );
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'LogoutApiService',
      );
      developer.log(
        'Response Body: ${response.body}',
        name: 'LogoutApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return;
        } else {
          throw Exception(responseData['message'] ?? 'Logout failed');
        }
      } else {
        String errorMsg = 'Failed to logout';
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          errorMsg = responseData['message'] ?? errorMsg;
        } catch (_) {}
        throw Exception('$errorMsg (Status code: ${response.statusCode})');
      }
    } catch (e) {
      developer.log(
        'Error during logout API execution',
        name: 'LogoutApiService',
        error: e,
      );
      rethrow;
    }
  }
}
