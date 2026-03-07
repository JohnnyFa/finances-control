import 'package:finances_control/core/http/dio_get_client.dart';
import 'package:finances_control/core/http/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final class DioImpl implements DioGetClient {
  final Dio client;

  DioImpl({required this.client}) {
    if (kDebugMode) {
      client.interceptors.add(LoggingInterceptor());
    }
  }

  @override
  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.get(
        url,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
