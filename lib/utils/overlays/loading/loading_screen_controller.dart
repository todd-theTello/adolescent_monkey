import 'package:flutter/foundation.dart' show immutable;

/// type definition of [CloseLoadingScreen]
typedef CloseLoadingScreen = bool Function();

/// type definition of [UpdateLoadingScreen]

typedef UpdateLoadingScreen = bool Function(String? text);

/// loading overlay controller
@immutable
class AuthenticationLoadingScreenController {
  /// loading overlay constructor
  const AuthenticationLoadingScreenController({
    required this.close,
    required this.update,
  });

  /// closes the overlay
  final CloseLoadingScreen close;

  /// updates the overlay
  final UpdateLoadingScreen update;
}
