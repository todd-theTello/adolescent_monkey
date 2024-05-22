import 'package:flutter/foundation.dart' show kDebugMode;

extension ObjectExtensions on Object? {
  void get log {
    if (kDebugMode) {
      print(toString());
    }
  }

  Object? get objectValueOrNull => this;

  /// checks whether the value of an object is null
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}
