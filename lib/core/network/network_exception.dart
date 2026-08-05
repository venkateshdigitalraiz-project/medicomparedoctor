import 'error_mapper.dart';

/// Centralized exception representing any network/API error.
///
/// * [message] – user‑friendly message that should be shown in the UI.
/// * [statusCode] – HTTP status code when available.
/// * [originalException] – the low‑level exception (e.g., SocketException).
/// * [rawResponse] – optional raw body returned by the server for debugging.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final Exception? originalException;
  final String? rawResponse;

  NetworkException({
    required this.message,
    this.statusCode,
    this.originalException,
    this.rawResponse,
  });

  /// Factory for creating an exception from an HTTP status code.
  factory NetworkException.fromStatusCode(int code, String? body) {
    final userMessage = ErrorMapper.mapStatusCode(code);
    return NetworkException(
      message: userMessage,
      statusCode: code,
      originalException: Exception('HTTP $code'),
      rawResponse: body,
    );
  }

  @override
  String toString() =>
      'NetworkException(message: $message, statusCode: $statusCode)';
}
