import 'package:flutter/material.dart';
import 'package:rate_master/shared/theme/theme.dart';

class ProfileVector extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = AppColors.vectorsBackground;
    path = Path();
    path.lineTo(0, size.height * 0.75);
    path.cubicTo(0, size.height * 0.75, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.75, size.width, size.height * 0.75);
    path.cubicTo(size.width * 0.57, size.height * 1.08, size.width * 0.44, size.height * 1.09, 0, size.height * 0.75);
    path.cubicTo(0, size.height * 0.75, 0, size.height * 0.75, 0, size.height * 0.75);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
