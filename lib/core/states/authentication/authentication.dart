import 'dart:async';

import 'package:adolescence_chat_bot/core/states/authentication/authorization.dart';
import 'package:adolescence_chat_bot/utils/extensions/date_time.dart';
import 'package:adolescence_chat_bot/utils/extensions/objects.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';
import '../../repository/repository.dart';
import '../../server/endpoints.dart';
import '../../server/network_client.dart';

class AuthenticationNotifier extends AsyncNotifier<void> {
  final Repository _repository = Repository();

  Future<void> authenticate({required AuthenticationRequestData data}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.makeRequest(
        path: data.firstName.isNull ? Endpoints.login : Endpoints.register,
        method: RequestMethod.post,
        data: data.toJson(),
        fromJson: (json) => json['access_token'] as String,
      );
      ref.read(routerConfigProvider.notifier).setLoggedIn(token: response);
    });
  }

  @override
  FutureOr<UserProfile?> build() => null;
}

final authenticationProvider = AsyncNotifierProvider<AuthenticationNotifier, void>(
  AuthenticationNotifier.new,
);

class AuthenticationRequestData {
  const AuthenticationRequestData({
    required this.email,
    required this.password,
    this.firstName,
    this.surname,
    this.gender,
    this.dateOfBirth,
  });
  final String email;
  final String password;
  final String? firstName;
  final String? surname;
  final String? gender;
  final DateTime? dateOfBirth;
  Map<String, dynamic> toJson() => {
        if (firstName.isNotNull) "firstName": firstName,
        if (surname.isNotNull) "lastName": surname,
        if (dateOfBirth.isNotNull) "dateOfBirth": dateOfBirth.dateTimeToString,
        if (gender.isNotNull) "gender": gender,
        "email": email,
        "password": password,
      };
}
