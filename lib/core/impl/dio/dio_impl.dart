import 'package:finances_control/core/impl/dio/dio_get_client.dart';
import 'package:dio/dio.dart';

final class DioImpl implements DioGetClient {
  final Dio client;

  DioImpl({required this.client}) {
    client.interceptors.addAll([
      //loggingInterceptor(),
    ]);
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
