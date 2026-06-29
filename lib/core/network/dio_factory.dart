import 'dart:async';

import 'package:dio/dio.dart';
import 'package:stockubl/app/config/app_config.dart';
import 'package:stockubl/core/logging/app_logger.dart';

abstract final class DioFactory {
  static Dio create(AppConfig config) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(_RestRetryInterceptor(dio));

    if (config.enableNetworkLogs) {
      dio.interceptors.add(const _SafeNetworkLogInterceptor());
    }

    return dio;
  }
}

final class _RestRetryInterceptor extends Interceptor {
  _RestRetryInterceptor(this._dio);

  static const _retryAttemptKey = 'stockubl.retry_attempt';
  static const _maxAttempts = 3;
  static const _retryableStatusCodes = {408, 429, 500, 502, 503, 504};

  final Dio _dio;

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(error)) {
      handler.next(error);
      return;
    }

    final currentAttempt =
        error.requestOptions.extra[_retryAttemptKey] as int? ?? 0;
    final nextAttempt = currentAttempt + 1;
    final delay = _retryDelay(error, currentAttempt);
    AppLogger.warning(
      'REST retry scheduled',
      scope: 'network',
      data: {
        'path': error.requestOptions.path,
        'statusCode': error.response?.statusCode,
        'attempt': nextAttempt,
        'delayMs': delay.inMilliseconds,
      },
    );

    await Future<void>.delayed(delay);

    try {
      final retryOptions = error.requestOptions.copyWith(
        extra: {
          ...error.requestOptions.extra,
          _retryAttemptKey: nextAttempt,
        },
      );
      final response = await _dio.fetch<Object?>(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    } on Object catch (retryError) {
      handler.next(
        DioException(
          requestOptions: error.requestOptions,
          error: retryError,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  bool _shouldRetry(DioException error) {
    if (error.requestOptions.method.toUpperCase() != 'GET') {
      return false;
    }
    if (error.type == DioExceptionType.cancel) {
      return false;
    }

    final attempt = error.requestOptions.extra[_retryAttemptKey] as int? ?? 0;
    if (attempt >= _maxAttempts) {
      return false;
    }

    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return _retryableStatusCodes.contains(statusCode);
    }

    return switch (error.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => true,
      _ => false,
    };
  }

  Duration _retryDelay(DioException error, int attempt) {
    final retryAfter = error.response?.headers.value('retry-after');
    final retryAfterSeconds = int.tryParse(retryAfter ?? '');
    if (retryAfterSeconds != null && retryAfterSeconds > 0) {
      return Duration(seconds: retryAfterSeconds.clamp(1, 10).toInt());
    }

    return Duration(milliseconds: 500 * (1 << attempt));
  }
}

final class _SafeNetworkLogInterceptor extends Interceptor {
  const _SafeNetworkLogInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      'REST request',
      scope: 'network',
      data: {
        'method': options.method,
        'path': options.path,
        'queryKeys': options.queryParameters.keys
            .where((key) => key.toLowerCase() != 'apikey')
            .toList(growable: false),
      },
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.info(
      'REST response',
      scope: 'network',
      data: {
        'path': response.requestOptions.path,
        'statusCode': response.statusCode,
      },
    );
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'REST failure',
      scope: 'network',
      data: {
        'path': error.requestOptions.path,
        'statusCode': error.response?.statusCode,
        'type': error.type.name,
      },
      error: error.message,
    );
    handler.next(error);
  }
}
