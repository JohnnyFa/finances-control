
import 'package:finances_control/core/route/base/base_route_path.dart';

enum HomePath implements BaseRoutePath {
  transaction('home/transaction'),
  profile('home/profile');

  const HomePath(this.path);

  @override
  final String path;
}