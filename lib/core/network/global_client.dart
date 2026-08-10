import 'package:dio/dio.dart';
import 'package:medicompare/core/network/connectivity_service.dart';
import 'package:medicompare/core/network/network_exception.dart';
import 'package:medicompare/core/network/error_mapper.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/main.dart';
import 'package:medicompare/core/ui/dialog_helper.dart';
import 'dart:developer' as developer;

class AppHttpClient {
  static final ConnectivityServiceImpl connectivityService =
      ConnectivityServiceImpl();

  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dioInstance = Dio(
      BaseOptions(
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        sendTimeout: AppConstants.apiTimeout,
      ),
    );

    dioInstance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final connected = await connectivityService.isConnected;
          if (!connected) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: NetworkException(message: ErrorMapper.mapNoInternet()),
                type: DioExceptionType.connectionError,
              ),
            );
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          developer.log(
            'API error exception – Exception: $e',
            name: 'AppHttpClient',
          );

          final String friendlyMessage;
          int? statusCode = e.response?.statusCode;

          if (statusCode != null && (statusCode < 200 || statusCode >= 300)) {
            friendlyMessage = ErrorMapper.mapStatusCode(statusCode);
          } else if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            friendlyMessage = ErrorMapper.mapTimeout();
          } else if (e.type == DioExceptionType.connectionError ||
              e.error is NetworkException ||
              e.message?.toLowerCase().contains('socketexception') == true ||
              e.message?.toLowerCase().contains('handshakeexception') == true) {
            friendlyMessage = ErrorMapper.mapNoInternet();
          } else {
            friendlyMessage = ErrorMapper.mapUnknown();
          }

          // Show the global error dialog using the friendly message only for Profile API
          final context = MyApp.navigatorKey.currentContext;
          if (context != null && context.mounted) {
            final bool isProfileApi = e.requestOptions.path.contains(
              '/doctor/profile',
            );
            if (isProfileApi) {
              DialogHelper.showGlobalErrorDialog(
                context,
                friendlyMessage,
                okButtonText: 'Login',
                shouldRedirect: true,
                showCancelButton: true,
              );
            }
          }

          final mappedException = NetworkException(
            message: friendlyMessage,
            statusCode: statusCode,
            originalException: e,
            rawResponse: e.response?.data?.toString(),
          );

          return handler.next(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: mappedException,
              message: friendlyMessage,
            ),
          );
        },
      ),
    );

    return dioInstance;
  }
}
