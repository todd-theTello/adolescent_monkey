/// User Profile object
class UserProfile {
  /// User profile constructor
  UserProfile({required this.age, required this.firstName, required this.gender, required this.disability});

  /// Factory constructor for the user profile  object
  factory UserProfile.fromJson(dynamic json) {
    return UserProfile(
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      firstName: json['first_name'] as String?,
      disability: json['type'] as String?,
    );
  }
  final int? age;
  final String? firstName;
  final String? gender;
  final String? disability;
}
