import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Future<void> pushRoute({required Widget child}) async {
    return Navigator.of(this).push<void>(MaterialPageRoute(builder: (_) => child));
  }

  Future<void> showErrorSnackBar({required String message}) async {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  Future<void> showSuccessSnackBar({required String message}) async {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(backgroundColor: tertiaryColor, content: Text(message)),
    );
  }

  /// get text styles from context
  TextStyle get displayLarge => Theme.of(this).textTheme.displayLarge!;
  TextStyle get displayMedium => Theme.of(this).textTheme.displayMedium!;
  TextStyle get displaySmall => Theme.of(this).textTheme.displaySmall!;
  TextStyle get headerLarge => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get headerMedium => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get headerSmall => Theme.of(this).textTheme.headlineSmall!;
  TextStyle get titleLarge => Theme.of(this).textTheme.titleLarge!;
  TextStyle get titleMedium => Theme.of(this).textTheme.titleMedium!;
  TextStyle get titleSmall => Theme.of(this).textTheme.titleSmall!;
  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get bodyMedium => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get bodySmall => Theme.of(this).textTheme.bodySmall!;
  TextStyle get labelLarge => Theme.of(this).textTheme.labelLarge!;
  TextStyle get labelMedium => Theme.of(this).textTheme.labelMedium!;
  TextStyle get labelSmall => Theme.of(this).textTheme.labelSmall!;

  /// Get colors from context
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get tertiaryColor => Theme.of(this).colorScheme.tertiary;
}
