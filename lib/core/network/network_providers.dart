import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/app/config/app_config_provider.dart';
import 'package:stockubl/core/network/api_client.dart';
import 'package:stockubl/core/network/dio_factory.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return DioFactory.create(ref.watch(appConfigProvider));
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(ref.watch(dioProvider));
}
