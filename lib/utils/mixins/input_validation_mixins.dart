/// mixin to check input validators
mixin InputValidationMixin {
  ///
  final emailInputPattern = '[a-z0-9@-_.]';

  ///
  static const emailValidationPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  /// checks if provided password is valid

  bool isPasswordValid({required String password}) => password.length >= 8;

  ///
  final passwordPattern = r'[a-z0-9A-Z@$!%*?&^#;_+-]';

  ///
  bool validPassword({required String passwordText}) {
    final regex = RegExp(r'^[a-z0-9A-Z@$!%*?&^#;_+-]{8,}$');
    return regex.hasMatch(passwordText);
  }

  /// Checks if provided email is valid
  bool isEmailValid({required String email}) {
    /// define regular expression
    final regex = RegExp(emailValidationPattern);
    return regex.hasMatch(email);
  }

  /// Check if provided phone number is valid
  bool isPhoneNumberValid({required String phoneNumber}) {
    /// define regEx pattern
    const pattern = r'^\d{9,}$';

    /// define regular expression
    final regex = RegExp(pattern);
    return regex.hasMatch(phoneNumber);
  }
}

/// input pattern for email text fields
const kEmailInputPattern = '[a-z0-9@-_.]';

/// email validation pattern
const kEmailValidationPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

/// input pattern for password text fields
const kPasswordInputPattern = r'[a-z0-9A-Z@$!%*?&^#;_+-]';

/// password validation pattern
const kPasswordValidationPattern = r'^(?=.*[a-z0-9A-Z@$!%*?&^#;_+-]).{8,}$';

/// confirm password validation pattern
String kConfirmPasswordValidationPattern({required String password}) => r'([$password])(?:(?=(\\?))\2.)*\1';

/// phone number input pattern, accepts country code as specified in the first part
const kPhoneNumberInputPattern = r'^\+?[0-9]*$';

/// phone number validation pattern
/// Please note that I have no idea why the pattern accepts a 9 as valid state and not 10
/// (ie. 10 does not trigger valid)
const kPhoneNumberValidationPattern = r'^(\+?[0-9]).{9,}$';

///
bool kIsPasswordValid({required String passwordText}) {
  final regex = RegExp(r'^[a-z0-9A-Z@$!%*?&^#;_+-]{8,}$');
  return regex.hasMatch(passwordText);
}

/// Checks if provided email is valid
bool kIsEmailValid({required String email}) {
  final regex = RegExp(kEmailValidationPattern);
  return regex.hasMatch(email);
}
