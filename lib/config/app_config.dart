import 'flavors.dart';

class AppConfig {
  static const int pageSize = 10;
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  static String get googleBooksApiKey =>
      'AIzaSyDVGX8tbx-f2KAbdg_v_WK_1apnP7hYxpU';

  static String get apiBaseUrl => FlavorConfig.apiBaseUrl;

  static String get appName => FlavorConfig.appName;

  static String get environment => FlavorConfig.environment;

  static bool get isProduction => FlavorConfig.flavor == Flavor.production;

  static bool get isDevelopment => FlavorConfig.flavor == Flavor.dev;

  static bool get isStaging => FlavorConfig.flavor == Flavor.staging;
}
