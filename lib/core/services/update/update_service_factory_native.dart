import 'dart:io';

import 'package:finances_control/core/services/update/update_service.dart';
import 'package:finances_control/core/services/update/update_service_impl.dart';
import 'package:finances_control/core/services/update/update_service_ios_impl.dart';
import 'package:finances_control/core/services/update/update_service_stub.dart';

UpdateService createUpdateService() => Platform.isAndroid
    ? UpdateServiceImpl()
    : Platform.isIOS
        ? UpdateServiceIosImpl()
        : UpdateServiceStub();
