import 'package:adolescence_chat_bot/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';

///
class CircleContainer extends StatelessWidget {
  ///
  const CircleContainer({super.key, this.color, this.child, this.padding, this.border, this.width, this.height});

  ///
  final double? height;

  ///
  final double? width;

  ///
  final Color? color;

  ///
  final Widget? child;

  ///
  final EdgeInsetsGeometry? padding;

  ///
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}

class Dot extends StatelessWidget {
  ///
  const Dot({super.key, this.color, this.border, this.diameter});

  ///
  final double? diameter;

  ///
  final Color? color;

  ///
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter ?? 8,
      width: diameter ?? 8,
      decoration: BoxDecoration(color: color ?? context.primaryColor, border: border, shape: BoxShape.circle),
    );
  }
}
