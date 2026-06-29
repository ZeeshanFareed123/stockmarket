sealed class AppFailure {
  const AppFailure({required this.code, required this.message, this.cause});

  final String code;
  final String message;
  final Object? cause;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure({super.cause})
    : super(
        code: 'network_failure',
        message: 'Please check your internet connection.',
      );
}

final class ServerFailure extends AppFailure {
  const ServerFailure({super.cause})
    : super(
        code: 'server_failure',
        message: 'The service is temporarily unavailable.',
      );
}

final class RateLimitFailure extends AppFailure {
  const RateLimitFailure({super.cause})
    : super(
        code: 'rate_limit_failure',
        message:
            'Market data limit reached. Please wait a minute before retrying.',
      );
}

final class ConfigurationFailure extends AppFailure {
  const ConfigurationFailure({required super.message, super.cause})
    : super(code: 'configuration_failure');
}

final class DataParsingFailure extends AppFailure {
  const DataParsingFailure({super.cause})
    : super(
        code: 'data_parsing_failure',
        message: 'The market data response could not be read.',
      );
}

final class ProviderFailure extends AppFailure {
  const ProviderFailure({required super.message, super.cause})
    : super(code: 'provider_failure');
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure({super.cause})
    : super(
        code: 'unknown_failure',
        message: 'Something went wrong. Please try again.',
      );
}
