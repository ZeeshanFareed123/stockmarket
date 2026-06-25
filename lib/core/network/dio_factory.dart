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

    if (config.enableNetworkLogs) {
      dio.interceptors.add(const _SafeNetworkLogInterceptor());
    }

    return dio;
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
