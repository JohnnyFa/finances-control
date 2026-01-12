abstract interface class DioGetClient {
  Future<dynamic> get({required String url,  Map<String, dynamic>? queryParameters});
}
