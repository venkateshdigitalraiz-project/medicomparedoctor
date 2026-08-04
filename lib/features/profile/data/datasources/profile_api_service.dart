import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/features/profile/data/models/user_profile_model.dart';

abstract class ProfileApiService {
  Future<UserProfileModel> fetchProfile();
}

class ProfileApiServiceImpl implements ProfileApiService {
  final http.Client client;
  final String baseUrl;

  ProfileApiServiceImpl({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  @override
  Future<UserProfileModel> fetchProfile() async {
    final url = Uri.parse('$baseUrl/doctor/profile');
    final token = await SessionManager.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    developer.log(
      '=== GET PROFILE API REQUEST START ===',
      name: 'ProfileApiService',
    );
    developer.log('URL: $url', name: 'ProfileApiService');
    developer.log('Headers: $headers', name: 'ProfileApiService');

    try {
      final response = await client
          .get(url, headers: headers)
          .timeout(AppConstants.apiTimeout);

      developer.log(
        '=== GET PROFILE API RESPONSE ===',
        name: 'ProfileApiService',
      );
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'ProfileApiService',
      );
      developer.log(
        'Response Body: ${response.body}',
        name: 'ProfileApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return UserProfileModel.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to get profile');
        }
      } else {
        String errorMsg = 'Failed to get profile';
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          errorMsg = responseData['message'] ?? errorMsg;
        } catch (_) {}
        throw Exception('$errorMsg (Status code: ${response.statusCode})');
      }
    } catch (e) {
      developer.log(
        'Error during get profile API execution',
        name: 'ProfileApiService',
        error: e,
      );
      rethrow;
    }
  }
}
