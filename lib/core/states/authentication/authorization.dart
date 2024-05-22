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
    final token = await SecureStorage.readFromStorage(key: SecureStorage.token);
    state = switch (token.isNotNull && token!.isNotEmpty) {
      true => AuthorizationState.authorized,
      _ => AuthorizationState.login
    };
    _routerListener?.call();
  }

  void setLogin() {
    state = AuthorizationState.login;
    _routerListener?.call();
  }

  void setRegister() {
    state = AuthorizationState.register;
    _routerListener?.call();
  }

  /// set the the value on onboarded to true
  Future<void> setLoggedIn({required String token}) async {
    await SecureStorage.writeToStorage(key: SecureStorage.token, value: token);
    await checkOnboarding();
  }

  /// set the the value on onboarded to true
  Future<void> setLogOut() async {
    await SecureStorage.deleteFromStorage(key: SecureStorage.token);
    await checkOnboarding();
  }

  /// redirect login to be used by go router
  String? redirect({required GoRouterState goRouterState, required bool showErrorIfNonExistentRoute}) {
    if (state == AuthorizationState.initial) return null;
    final isLoggedIn = state == AuthorizationState.authorized;
    if (isLoggedIn) return '/home';

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
