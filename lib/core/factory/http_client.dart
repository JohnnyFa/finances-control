import 'package:finances_control/core/constans/app_constants.dart';
import 'package:finances_control/core/impl/dio/dio_get_client.dart';
import 'package:finances_control/core/impl/dio/dio_impl.dart';
import 'package:dio/dio.dart';

DioGetClient makeHttpGetClient() => DioImpl(
  client: Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
  )),
);
