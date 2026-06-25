import 'package:dio/dio.dart';

final class ApiClient {
  const ApiClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    required T Function(Object? data) decode,
    Map<String, Object?>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Object?>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );

    return decode(response.data);
  }

  Future<T> post<T>(
    String path, {
    required T Function(Object? data) decode,
    Object? data,
    Map<String, Object?>? headers,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post<Object?>(
      path,
      data: data,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );

    return decode(response.data);
  }
}
