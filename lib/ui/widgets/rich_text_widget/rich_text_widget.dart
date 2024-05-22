import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'base_text.dart';
import 'link_text.dart';

/// Custom text widget
class RichTextWidget extends StatelessWidget {
  /// constructor
  const RichTextWidget({required this.texts, this.styleForAll, this.customStyle, this.textAlign, super.key});

  /// iterable of texts in the rich text widget

  final TextStyle? styleForAll;

  /// Default style for all texts

  final TextStyle? customStyle;

  /// Style applied to custom text

  final Iterable<BaseText> texts;

  /// Text alignment

  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: texts
            .map(
              (baseText) => switch (baseText) {
                CustomText() => TextSpan(
                    text: baseText.text,
                    style: baseText.style ??
                        customStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.primaryColor,
                        ),
                    recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
                  ),
                _ => TextSpan(
                    text: baseText.text,
                    style: baseText.style ?? styleForAll ?? theme.textTheme.bodyMedium,
                  )
              },
            )
            .toList(),
      ),
    );
  }
}
