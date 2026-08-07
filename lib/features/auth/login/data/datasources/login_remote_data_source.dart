import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/constants/app_strings.dart';
import 'package:medicompare/core/network/network_exception.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio client;
  final String baseUrl;

  LoginRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final urlStr = '$baseUrl${AppConstants.loginEndpoint}';
    final headers = {'Content-Type': 'application/json'};
    final body = request.toJson();

    developer.log('=== API REQUEST START ===', name: 'LoginRemoteDataSource');
    developer.log('Base URL: $baseUrl', name: 'LoginRemoteDataSource');
    developer.log('Full Request URL: $urlStr', name: 'LoginRemoteDataSource');
    developer.log('Headers: $headers', name: 'LoginRemoteDataSource');
    developer.log('Body: $body', name: 'LoginRemoteDataSource');

    try {
      final response = await client.post(
        urlStr,
        options: Options(headers: headers),
        data: body,
      );

      developer.log(
        '=== API RESPONSE SUCCESS ===',
        name: 'LoginRemoteDataSource',
      );
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'LoginRemoteDataSource',
      );
      developer.log(
        'Response Body: ${response.data}',
        name: 'LoginRemoteDataSource',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json;
        if (response.data is String) {
          json = jsonDecode(response.data) as Map<String, dynamic>;
        } else {
          json = response.data as Map<String, dynamic>;
        }
        return LoginResponseModel.fromJson(json);
      } else {
        throw Exception(
          '${AppStrings.failedToLogin} Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e, stacktrace) {
      developer.log(
        '=== API RESPONSE ERROR (FALLING BACK TO MOCK) ===',
        name: 'LoginRemoteDataSource',
        error: e,
        stackTrace: stacktrace,
      );

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.error is NetworkException ||
          e.message?.toLowerCase().contains('failed host lookup') == true ||
          e.message?.toLowerCase().contains('connection refused') == true) {
        developer.log(
          'Returning mock successful login response for demo purposes due to connection error.',
          name: 'LoginRemoteDataSource',
        );
        await Future.delayed(const Duration(milliseconds: 800)); // simulate latency
        return LoginResponseModel(
          success: true,
          message: AppStrings.otpSentMock,
          data: LoginData(phone: request.phone),
        );
      }
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      rethrow;
    }
  }
}
