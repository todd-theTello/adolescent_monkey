import 'package:adolescence_chat_bot/core/database/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/extensions/objects.dart';
import '../../database/secure_storage.dart';
import '../../routes/routes.dart';

/// defines a set of authorization levels
enum AuthorizationState {
  /// initial authorization level
  initial,

  /// Authorization level of a successfully logged in user
  authorized,

  /// Authorization level of a user yet to pass authentication
  login,
  register,
  onboarding,
}

/// Router config provider
final routerConfigProvider = NotifierProvider<RouterConfigNotifier, AuthorizationState>(
  () => RouterConfigNotifier()..checkOnboarding(),
);

/// Onboarding state
class RouterConfigNotifier extends Notifier<AuthorizationState> implements Listenable {
  VoidCallback? _routerListener;

  /// check the onboarding state depending on the value from local db
  Future<void> checkOnboarding() async {
    if (LocalPreference.isLoggedIn == false) {
      SecureStorage.deleteFromStorage(key: SecureStorage.token);
    }
    final token = await SecureStorage.readFromStorage(key: SecureStorage.token);
    state = switch (token.isNotNull && token!.isNotEmpty) {
      true => AuthorizationState.authorized,
      _ => (!LocalPreference.hasOnboarded) ? AuthorizationState.onboarding : AuthorizationState.login,
    };
    _routerListener?.call();
  }

  void setLogin() {
    LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_ON_BOARDED, value: true);
    state = AuthorizationState.login;
    _routerListener?.call();
  }

  void setRegister() {
    LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_ON_BOARDED, value: true);

    state = AuthorizationState.register;
    _routerListener?.call();
  }

  /// set the the value on onboarded to true
  Future<void> setLoggedIn({required String token}) async {
    await SecureStorage.writeToStorage(key: SecureStorage.token, value: token);
    await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_IS_LOGIN, value: true);
    await checkOnboarding();
  }

  /// set the the value on onboarded to true
  Future<void> setOnboarded() async {
    await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_ON_BOARDED, value: true);
    await checkOnboarding();
  }

  /// set the the value on onboarded to true
  Future<void> setLogOut() async {
    await SecureStorage.deleteFromStorage(key: SecureStorage.token);
    await checkOnboarding();
  }

  /// redirect login to be used by go router
  String? redirect({required GoRouterState goRouterState, required bool showErrorIfNonExistentRoute}) {
    final isLoggedIn = state == AuthorizationState.authorized;
    if (state == AuthorizationState.initial) return null;
    if (!LocalPreference.hasOnboarded) return '/';

    final isRegister = state == AuthorizationState.register;
    if (isRegister) return '/register';

    final routeExists = _routeExists(goRouterState.matchedLocation);

    final loginRoutes = goRouterState.matchedLocation.startsWith('/login');
    if (isLoggedIn && routeExists) {
      return loginRoutes ? '/home' : null;
    }
    return loginRoutes || (showErrorIfNonExistentRoute && !routeExists) ? null : '/login';
  }

  @override
  AuthorizationState build() => AuthorizationState.initial;

  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;

  bool _routeExists(String route) {
    try {
      return ref.read(goRouterProvider).configuration.findMatch(route).matches.isNotEmpty;
    } catch (err) {
      return false;
    }
  }
}
