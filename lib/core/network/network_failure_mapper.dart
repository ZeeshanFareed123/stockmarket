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
        DioExceptionType.badResponse => ServerFailure(cause: error),
        _ => UnknownFailure(cause: error),
      };
    }

    if (error is FormatException) {
      return DataParsingFailure(cause: error);
    }

    return UnknownFailure(cause: error);
  }
}
