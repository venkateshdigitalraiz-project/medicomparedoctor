import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/constants/app_strings.dart';
import 'package:medicompare/features/auth/login/data/models/login_request_model.dart';
import 'package:medicompare/features/auth/login/data/models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final url = Uri.parse('$baseUrl${AppConstants.loginEndpoint}');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    developer.log('=== API REQUEST START ===', name: 'AuthRemoteDataSource');
    developer.log('Base URL: $baseUrl', name: 'AuthRemoteDataSource');
    developer.log('Full Request URL: $url', name: 'AuthRemoteDataSource');
    developer.log('Headers: $headers', name: 'AuthRemoteDataSource');
    developer.log('Body: $body', name: 'AuthRemoteDataSource');
    developer.log(
      'API method client.post() is about to be called.',
      name: 'AuthRemoteDataSource',
    );

    try {
      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(AppConstants.apiTimeout);

      developer.log(
        '=== API RESPONSE SUCCESS ===',
        name: 'AuthRemoteDataSource',
      );
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'AuthRemoteDataSource',
      );
      developer.log(
        'Response Body: ${response.body}',
        name: 'AuthRemoteDataSource',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          '${AppStrings.failedToLogin} Status code: ${response.statusCode}',
        );
      }
    } catch (e, stacktrace) {
      developer.log(
        '=== API RESPONSE ERROR (FALLING BACK TO MOCK) ===',
        name: 'AuthRemoteDataSource',
        error: e,
        stackTrace: stacktrace,
      );

      if (e is SocketException ||
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('Connection refused') ||
          e is http.ClientException) {
        developer.log(
          'Returning mock successful login response for demo purposes due to connection error.',
          name: 'AuthRemoteDataSource',
        );
        await Future.delayed(
          const Duration(milliseconds: 800),
        ); // simulate latency
        return LoginResponseModel(
          success: true,
          message: AppStrings.otpSentMock,
          data: LoginData(phone: request.phone),
        );
      }
      rethrow;
    }
  }
}
