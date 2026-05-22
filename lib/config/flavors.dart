enum Flavor { dev, staging, production }

class FlavorConfig {
  static late Flavor _flavor;
  static late String _apiBaseUrl;

  static Flavor get flavor => _flavor;
  static String get apiBaseUrl => _apiBaseUrl;

  static void setup({required Flavor flavor}) {
    _flavor = flavor;
    _apiBaseUrl = _getApiBaseUrl(flavor);
  }

  static String _getApiBaseUrl(Flavor flavor) {
    return switch (flavor) {
      Flavor.dev => 'https://www.googleapis.com/books/v1',
      Flavor.staging => 'https://www.googleapis.com/books/v1',
      Flavor.production => 'https://www.googleapis.com/books/v1',
    };
  }

  static String get appName {
    return switch (_flavor) {
      Flavor.dev => 'BookBuddy (Dev)',
      Flavor.staging => 'BookBuddy (Staging)',
      Flavor.production => 'BookBuddy',
    };
  }

  static String get environment {
    return switch (_flavor) {
      Flavor.dev => 'Development',
      Flavor.staging => 'Staging',
      Flavor.production => 'Production',
    };
  }
}
