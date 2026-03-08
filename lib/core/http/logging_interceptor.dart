import 'package:finances_control/core/logger/app_logger.dart';
import 'package:dio/dio.dart';

/// A Dio [Interceptor] that logs HTTP activity to the terminal in debug mode.
///
/// PRIVACY: Only the HTTP method, URL *path* (no query params), and status
/// code are logged. Request bodies, auth headers, query parameters, and
/// response payloads are never logged.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = Uri.tryParse(options.path)?.path ?? options.path;
    AppLogger.http('→ ${options.method.toUpperCase()} $path');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final path =
        Uri.tryParse(response.requestOptions.path)?.path ??
        response.requestOptions.path;
    AppLogger.http('← ${response.statusCode} $path');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final path =
        Uri.tryParse(err.requestOptions.path)?.path ??
        err.requestOptions.path;
    AppLogger.error(
      'HTTP ${err.requestOptions.method.toUpperCase()} $path → ${err.type}',
    );
    handler.next(err);
  }
}
