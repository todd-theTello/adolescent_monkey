import 'dart:convert';

import 'package:crypto/crypto.dart' show sha256;

/// string extensions
extension T on String? {
  /// removes all commas(",") from string
  String get sanitize {
    return this!.replaceAll(',', '');
  }

  String? removeCharacters({required String characters}) {
    return this?.replaceAll(characters, '');
  }

  String? get removePhoneNumberFirstZero {
    if (this!.startsWith('0')) {
      return this!.replaceFirst('0', '');
    }
    return this;
  }

  /// Returns the sha256 hash of input in hex notation.
  String get sha256ofString {
    final bytes = utf8.encode(this!);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
