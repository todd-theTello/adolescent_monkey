import 'package:adolescence_chat_bot/ui/views/home.dart';
import 'package:adolescence_chat_bot/ui/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../ui/views/login.dart';
import '../states/authentication/authorization.dart';

/// create a provider to access the go router configuration
final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final router = ref.read(routerConfigProvider.notifier);

    return GoRouter(
      refreshListenable: router,
      redirect: (context, state) => router.redirect(goRouterState: state, showErrorIfNonExistentRoute: true),
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),
      ],
    );
  },
);

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
        context: context,
        settings: this,
        builder: builder,
        anchorPoint: anchorPoint,
        barrierColor: barrierColor ?? Colors.black.withOpacity(0.6),
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        themes: themes,
      );
}
