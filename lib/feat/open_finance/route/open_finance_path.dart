import 'package:finances_control/core/route/base/base_route_path.dart';

enum OpenFinancePath implements BaseRoutePath {
  home('/open-finance');

  const OpenFinancePath(this.path);

  @override
  final String path;
}
