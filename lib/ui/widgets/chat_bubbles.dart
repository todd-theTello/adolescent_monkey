import 'package:adolescence_chat_bot/ui/theme/colors.dart';
import 'package:adolescence_chat_bot/utils/extensions/build_context.dart';
import 'package:flutter/material.dart';

class UserChatBubble extends CustomPainter {
  UserChatBubble({required this.context});
  final BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = kDarkColor.shade300
      ..style = PaintingStyle.fill;

    double width = size.width;
    double height = size.height;

    Path path = Path()
      ..moveTo(width, height)
      ..lineTo(width - 16, height - 8)
      ..lineTo(20, height - 8)
      ..quadraticBezierTo(0, height - 8, 0, height - 28)
      ..lineTo(0, 20)
      ..quadraticBezierTo(0, 0, 20, 0)
      ..lineTo(width - 20, 0)
      ..quadraticBezierTo(width, 0, width, 20)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BotChatBubble extends CustomPainter {
  BotChatBubble({required this.context});
  final BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = context.primaryColor
      ..style = PaintingStyle.fill;

    double width = size.width;
    double height = size.height;

    Path path = Path()
      ..moveTo(width, height - 32)
      ..quadraticBezierTo(width, height - 16, width - 16, height - 16)
      ..lineTo(16, height - 16)
      ..quadraticBezierTo(0, height, 0, height - 16)
      ..lineTo(0, 20)
      ..quadraticBezierTo(0, 0, 20, 0)
      ..lineTo(width - 20, 0)
      ..quadraticBezierTo(width, 0, width, 20)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
