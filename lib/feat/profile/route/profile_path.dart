import 'package:finances_control/core/route/base/base_route_path.dart';

enum ProfilePath implements BaseRoutePath {
  profile('profile'),
  accountSettings('profile/account-settings'),
  financialSettings('profile/financial-settings'),
  preferences('profile/preferences');

  const ProfilePath(this.path);

  @override
  final String path;
}
