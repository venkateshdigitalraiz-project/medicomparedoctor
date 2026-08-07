import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/features/profile/data/models/user_profile_model.dart';
import 'package:medicompare/core/network/network_exception.dart';

abstract class ProfileApiService {
  Future<UserProfileModel> fetchProfile();
}

class ProfileApiServiceImpl implements ProfileApiService {
  final Dio client;
  final String baseUrl;

  ProfileApiServiceImpl({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  @override
  Future<UserProfileModel> fetchProfile() async {
    final urlStr = '$baseUrl${AppConstants.profileEndpoint}';
    final token = await SessionManager.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    developer.log(
      '=== GET PROFILE API REQUEST START ===',
      name: 'ProfileApiService',
    );
    developer.log('URL: $urlStr', name: 'ProfileApiService');
    developer.log('Headers: $headers', name: 'ProfileApiService');

    try {
      final response = await client.get(
        urlStr,
        options: Options(headers: headers),
      );

      developer.log(
        '=== GET PROFILE API RESPONSE ===',
        name: 'ProfileApiService',
      );
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'ProfileApiService',
      );
      developer.log(
        'Response Body: ${response.data}',
        name: 'ProfileApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData = jsonDecode(response.data);
        } else {
          responseData = response.data as Map<String, dynamic>;
        }
        if (responseData['success'] == true) {
          return UserProfileModel.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to get profile');
        }
      } else {
        String errorMsg = 'Failed to get profile';
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
        'Error during get profile API execution',
        name: 'ProfileApiService',
        error: e,
      );
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
    }
  }
}
