import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void debug(String message, {String scope = 'app', Object? data}) {
    _write('DEBUG', message, scope: scope, data: data);
  }

  static void info(String message, {String scope = 'app', Object? data}) {
    _write('INFO', message, scope: scope, data: data);
  }

  static void warning(
    String message, {
    String scope = 'app',
    Object? data,
    Object? error,
  }) {
    _write('WARNING', message, scope: scope, data: data, error: error);
  }

  static void error(
    String message, {
    String scope = 'app',
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(
      'ERROR',
      message,
      scope: scope,
      data: data,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _write(
    String level,
    String message, {
    required String scope,
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final suffix = data == null ? '' : ' ${_encode(data)}';
    developer.log(
      '$message$suffix',
      name: 'StockUBL.$scope',
      error: error,
      stackTrace: stackTrace,
    );

    if (kDebugMode) {
      debugPrint('[$level][$scope] $message$suffix');
      if (error != null) {
        debugPrint('[$level][$scope] error=$error');
      }
    }
  }

  static String _encode(Object data) {
    try {
      return jsonEncode(data);
    } on Object {
      return data.toString();
    }
  }
}
