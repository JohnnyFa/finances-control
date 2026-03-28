import 'package:finances_control/core/route/base/base_route_path.dart';

enum HomePath implements BaseRoutePath {
  transactions('home/transactions'),
  transaction('home/transaction'),
  budget('home/budget');

  const HomePath(this.path);

  @override
  final String path;
}
