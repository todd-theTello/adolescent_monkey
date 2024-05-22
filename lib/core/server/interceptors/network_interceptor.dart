import 'dart:async';

import 'package:dio/dio.dart';

import '../../database/secure_storage.dart';

/// Authorization interceptor
class NetworkInterceptor extends QueuedInterceptor {
  @override
  FutureOr<dynamic>? onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if ((err.response?.statusCode ?? 0) == 401) {}
    handler.next(err);
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final bearerToken = await SecureStorage.readFromStorage(key: 'token');

    options.headers.addAll({
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    });
    handler.next(options);
  }
}
