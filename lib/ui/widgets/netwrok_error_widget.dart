import 'package:flutter/material.dart';

import '../../../utils/Space/vertical_space.dart';

class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({required this.message, required this.onPressed, super.key});
  final String message;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          kVerticalSpace16,
          FilledButton(onPressed: onPressed, child: const Text('Retry')),
        ],
      ),
    );
  }
}
