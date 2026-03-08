enum AppFlavor {
  dev,
  prod,
}

class FlavorConfig {
  static late AppFlavor flavor;

  static bool get isDev => flavor == AppFlavor.dev;
  static bool get isProd => flavor == AppFlavor.prod;
}