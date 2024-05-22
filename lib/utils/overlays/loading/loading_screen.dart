import 'package:flutter/material.dart';

import '../../Space/vertical_space.dart';
import 'loading_screen_controller.dart';

/// loading overlay when authentication process is ongoing
class LoadingScreen {
  /// factory constructor authentication loading screen
  factory LoadingScreen.instance() => _shared;
  LoadingScreen._sharedInstance();
  static final _shared = LoadingScreen._sharedInstance();
  AuthenticationLoadingScreenController? _controller;

  /// opens the loading overlay
  void show({required BuildContext context, String? text}) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: text);
    }
  }

  /// closes the loading overlay
  void hide() {
    _controller?.close();
    _controller = null;
  }

  /// overlay view
  AuthenticationLoadingScreenController? showOverlay({required BuildContext context, String? text}) {
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final overlay = OverlayEntry(
        builder: (context) => Material(
          color: Colors.black.withOpacity(0.55),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24, width: 24, child: CircularProgressIndicator.adaptive()),
                  kVerticalSpace12,
                  const Text('Loading, Please wait...'),
                ],
              ),
            ),
          ),
        ),
      );
      state.insert(overlay);
      return AuthenticationLoadingScreenController(
        close: () {
          overlay.remove();
          return true;
        },
        update: (text) => true,
      );
    }
    return null;
  }
}
