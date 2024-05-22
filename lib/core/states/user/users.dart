import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';
import '../../repository/repository.dart';
import '../../server/endpoints.dart';
import '../../server/network_client.dart';

final userProvider = AutoDisposeAsyncNotifierProvider<UserAsyncNotifier, UserProfile?>(
  () => UserAsyncNotifier(),
);

class UserAsyncNotifier extends AutoDisposeAsyncNotifier<UserProfile?> {
  final Repository _repository = Repository();
  @override
  FutureOr<UserProfile?> build() => getUser();

  /// fetches the current user of a profile
  Future<UserProfile?> getUser() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _repository.makeRequest(
        path: Endpoints.user,
        method: RequestMethod.get,
        fromJson: UserProfile.fromJson,
      );
    });
    return state.value;
  }
}
