import 'package:finances_control/core/route/base/base_route_path.dart';

enum AppRoutePath implements BaseRoutePath {
  homePage('/');

  const AppRoutePath(this.path);

  @override
  final String path;
}