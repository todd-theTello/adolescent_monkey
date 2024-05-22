import 'package:dio/dio.dart';

extension FirebaseExtension on Object {
  String get errorToString {
    if (this is DioException) {
      return switch ((this as DioException).type) {
        DioExceptionType.connectionTimeout =>
          "Couldn't establish connection with our servers, please check your internet connection and try again",
        DioExceptionType.badResponse ||
        DioExceptionType.unknown =>
          (this as DioException).message ?? ' Something went wrong',
        _ => (this as DioException).type.toString(),
      };
    } else {
      return toString();
    }
  }
}
