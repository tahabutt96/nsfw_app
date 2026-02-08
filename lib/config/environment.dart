enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static Environment _environment = Environment.dev;

  static Environment get current => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static bool get isDev => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProd => _environment == Environment.prod;

  static String get appName {
    switch (_environment) {
      case Environment.dev:
        return 'NSFW App (Dev)';
      case Environment.staging:
        return 'NSFW App (Staging)';
      case Environment.prod:
        return 'NSFW App';
    }
  }

  static bool get enableCrashlyticsInDebug {
    switch (_environment) {
      case Environment.dev:
        return false;
      case Environment.staging:
        return true;
      case Environment.prod:
        return true;
    }
  }

  static bool get enableAnalyticsInDebug {
    switch (_environment) {
      case Environment.dev:
        return false;
      case Environment.staging:
        return true;
      case Environment.prod:
        return true;
    }
  }
}
