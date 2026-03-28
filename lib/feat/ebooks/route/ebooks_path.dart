import 'package:finances_control/core/route/base/base_route_path.dart';

enum EbooksPath implements BaseRoutePath {
  ebooks('ebooks');

  const EbooksPath(this.path);

  @override
  final String path;
}
