import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:taboo/main.dart';

class ClockPainter extends CustomPainter {
  static const Color lineColor = MyApp.primaryColor;
  static const Color lineEmptyColor = MyApp.disabledColor;
  static const double lineWidth = 6;
  final AnimationController animation;

  ClockPainter({
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = lineEmptyColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    const radian = Math.pi / 180;
    Offset center = new Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.height / 2),
      -Math.pi / 2,
      360 * radian,
      false,
      paint,
    );
    paint.color = lineColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.height / 2),
      -Math.pi / 2,
      animation.value * 360 * radian,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}
