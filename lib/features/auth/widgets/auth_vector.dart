import 'package:flutter/material.dart';
import 'package:rate_master/core/theme/theme.dart';

class AuthVector extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();


    // Path number 1


    paint.color = AppColors.vectorsBackground;
    path = Path();
    path.lineTo(0, size.height * 0.86);
    path.cubicTo(0, size.height * 0.86, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.86, size.width, size.height * 0.86);
    path.cubicTo(size.width, size.height * 0.89, size.width * 0.69, size.height, size.width / 2, size.height);
    path.cubicTo(size.width * 0.3, size.height, size.width * 0.01, size.height * 0.9, 0, size.height * 0.86);
    path.cubicTo(0, size.height * 0.86, 0, size.height * 0.86, 0, size.height * 0.86);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}