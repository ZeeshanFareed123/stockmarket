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

final class UnknownFailure extends AppFailure {
  const UnknownFailure({super.cause})
    : super(
        code: 'unknown_failure',
        message: 'Something went wrong. Please try again.',
      );
}
