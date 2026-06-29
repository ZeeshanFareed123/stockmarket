import 'package:dio/dio.dart';
import 'package:stockubl/core/error/app_failure.dart';

abstract final class NetworkFailureMapper {
  static AppFailure from(Object error) {
    if (error is AppFailure) {
      return error;
    }

    if (error is DioException) {
      return switch (error.type) {
        DioExceptionType.connectionError ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => NetworkFailure(cause: error),
        DioExceptionType.badResponse => _fromBadResponse(error),
        _ => UnknownFailure(cause: error),
      };
    }

    if (error is FormatException) {
      return DataParsingFailure(cause: error);
    }

    return UnknownFailure(cause: error);
  }

  static AppFailure _fromBadResponse(DioException error) {
    return switch (error.response?.statusCode) {
      401 || 403 => ProviderFailure(
        message: 'Market data API key is missing, expired, or not allowed.',
        cause: error,
      ),
      408 || 429 => RateLimitFailure(cause: error),
      500 || 502 || 503 || 504 => ServerFailure(cause: error),
      _ => ServerFailure(cause: error),
    };
  }
}
