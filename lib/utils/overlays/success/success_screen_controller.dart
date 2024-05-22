import 'package:flutter/foundation.dart' show immutable;

/// type definition of [CloseSuccessScreen]
typedef CloseSuccessScreen = bool Function();

/// type definition of [UpdateSuccessScreen]

typedef UpdateSuccessScreen = bool Function(String? text);

/// Success overlay controller
@immutable
class SuccessScreenController {
  /// Success overlay constructor
  const SuccessScreenController({
    required this.close,
    required this.update,
  });

  /// closes the overlay
  final CloseSuccessScreen close;

  /// updates the overlay
  final UpdateSuccessScreen update;
}
