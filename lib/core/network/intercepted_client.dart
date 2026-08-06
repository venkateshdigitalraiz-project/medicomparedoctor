import 'package:http/http.dart' as http;
import 'network_info.dart';
import 'toast_helper.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/network/error_mapper.dart';
import 'package:medicompare/main.dart';
import 'package:medicompare/core/ui/dialog_helper.dart';

class InterceptedClient extends http.BaseClient {
  final http.Client _inner;
  final NetworkInfo _networkInfo;

  InterceptedClient(this._inner, this._networkInfo);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      ToastHelper.showNoInternetToast();
      throw NetworkException(
        message: ErrorMapper.mapNoInternet(),
        originalException: http.ClientException('No Internet', request.url),
      );
    }
    try {
      // Execute the request
      final streamedResponse = await _inner.send(request);
      // Read response bytes to inspect status code and body
      final bytes = await streamedResponse.stream.toBytes();
      final responseBody = utf8.decode(bytes);
      final statusCode = streamedResponse.statusCode;
      if (statusCode < 200 || statusCode >= 300) {
        developer.log('API error – Status: $statusCode, Body: $responseBody', name: 'InterceptedClient');
        // 404 specific handling
        if (statusCode == 404) {
          final context = MyApp.navigatorKey.currentContext;
          if (context != null && context.mounted) {
            // Show session expired dialog and navigate to login
            DialogHelper.showSessionExpired(context);
          }
        }
        throw NetworkException(
          message: ErrorMapper.mapStatusCode(statusCode),
          statusCode: statusCode,
          originalException: Exception('HTTP $statusCode'),
          rawResponse: responseBody,
        );
      }
      // Rebuild a StreamedResponse for successful calls
      final stream = http.ByteStream.fromBytes(bytes);
      return http.StreamedResponse(
        stream,
        statusCode,
        request: streamedResponse.request,
        headers: streamedResponse.headers,
        reasonPhrase: streamedResponse.reasonPhrase,
        isRedirect: streamedResponse.isRedirect,
        persistentConnection: streamedResponse.persistentConnection,
      );
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      developer.log('API error exception – Exception: $e', name: 'InterceptedClient');
      final String userFriendlyMessage;
      final exceptionStr = e.toString().toLowerCase();
      if (exceptionStr.contains('timeout') || exceptionStr.contains('time out')) {
        userFriendlyMessage = ErrorMapper.mapTimeout();
      } else if (exceptionStr.contains('socketexception') || 
                 exceptionStr.contains('failed host lookup') || 
                 exceptionStr.contains('network is unreachable') ||
                 exceptionStr.contains('handshakeexception')) {
        userFriendlyMessage = ErrorMapper.mapNoInternet();
      } else {
        userFriendlyMessage = ErrorMapper.mapUnknown();
      }
      throw NetworkException(
        message: userFriendlyMessage,
        originalException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
