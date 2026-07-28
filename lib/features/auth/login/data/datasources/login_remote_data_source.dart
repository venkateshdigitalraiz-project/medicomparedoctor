import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/constants/app_strings.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  LoginRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final url = Uri.parse('$baseUrl${AppConstants.loginEndpoint}');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    developer.log('=== API REQUEST START ===', name: 'LoginRemoteDataSource');
    developer.log('Base URL: $baseUrl', name: 'LoginRemoteDataSource');
    developer.log('Full Request URL: $url', name: 'LoginRemoteDataSource');
    developer.log('Headers: $headers', name: 'LoginRemoteDataSource');
    developer.log('Body: $body', name: 'LoginRemoteDataSource');
    developer.log(
      'API method client.post() is about to be called.',
      name: 'LoginRemoteDataSource',
    );

    try {
      final response = await client
          .post(url, headers: headers, body: body)
          .timeout(AppConstants.apiTimeout);

      developer.log(
        '=== API RESPONSE SUCCESS ===',
        name: 'LoginRemoteDataSource',
      );
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'LoginRemoteDataSource',
      );
      developer.log(
        'Response Body: ${response.body}',
        name: 'LoginRemoteDataSource',
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
        name: 'LoginRemoteDataSource',
        error: e,
        stackTrace: stacktrace,
      );

      if (e is SocketException ||
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('Connection refused') ||
          e is http.ClientException) {
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
      rethrow;
    }
  }
}
