import 'package:dio/dio.dart';

import '../server/network_client.dart';

/// Repository class
class Repository {
  final _networkClient = const NetworkClient();

  /// This function communicates with the network client
  /// This sends your requests to the network clients and receives responses from the network client
  Future<T> makeRequest<T>({
    required String path,
    required RequestMethod method,
    required T Function(dynamic) fromJson,
    Object? data,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _networkClient.call(
      path: path,
      requestMethod: method,
      data: data,
      queryParams: queryParams,
    );
    return _mapResponse<T>(response, fromJson);
  }

  T _mapResponse<T>(Response<dynamic> response, T Function(dynamic) fromJson) {
    return fromJson(response.data);
  }
}
