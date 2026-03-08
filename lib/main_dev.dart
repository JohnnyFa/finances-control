import 'package:finances_control/main.dart';
import 'core/flavor/app_flavor.dart';

void main() {
  FlavorConfig.flavor = AppFlavor.dev;
  mainApp();
}