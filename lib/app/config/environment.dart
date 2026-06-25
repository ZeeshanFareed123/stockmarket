enum AppEnvironment {
  mock,
  twelveData,
  production;

  static AppEnvironment fromEnvironment() {
    const value = String.fromEnvironment('APP_ENV', defaultValue: 'mock');

    return AppEnvironment.values.firstWhere(
      (environment) => environment.name == value,
      orElse: () => AppEnvironment.mock,
    );
  }
}
