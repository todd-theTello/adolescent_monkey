// ignore_for_file: constant_identifier_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage entity for storage of sensitive data
class SecureStorage {
  static const _storage = FlutterSecureStorage();

  ///
  static String email = 'email';

  ///
  static String token = 'token';

  /// deletes all saved data on secure storage
  Future<void> deleteAll() async {
    await _storage.deleteAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  /// Delete the value of a specific key from local storage
  static Future<void> deleteFromStorage({required String key}) async {
    await _storage.delete(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  /// write the value of a key into storage
  static Future<void> writeToStorage({required String key, required String value}) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  /// read the value of a key from storage
  static Future<String?> readFromStorage({required String key}) async {
    final response = await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return response;
  }

  ///
  static IOSOptions _getIOSOptions() => IOSOptions.defaultOptions;

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
