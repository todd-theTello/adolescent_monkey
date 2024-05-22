import 'dart:async';

import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({required this.controller, this.call, this.hintText, super.key});

  /// Text controller to be used by the Search field
  final TextEditingController controller;

  /// Hint text
  final String? hintText;

  /// action to perform after timer
  final VoidCallback? call;
  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Timer? debounce;
  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: const Color(0xff222427),
      onChanged: (value) {
        if (debounce?.isActive ?? false) debounce?.cancel();

        /// Restart the debounce timer to a duration of 1.5 seconds
        debounce = Timer(const Duration(milliseconds: 1500), () {
          /// perform search request
          widget.call?.call();
          debounce?.cancel();
        });
      },
      onTapOutside: (_) {
        /// Disable the keyboard when user taps outside the text field or keyboard
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      onFieldSubmitted: (value) {
        widget.call?.call();
        debounce?.cancel();
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        constraints: const BoxConstraints(maxHeight: 48),
        prefixIcon: const Icon(Icons.search, color: Colors.black38),
        hintText: widget.hintText ?? 'Search for a product...',
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
