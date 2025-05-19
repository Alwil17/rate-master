import 'package:flutter/material.dart';
import 'package:rate_master/shared/theme/theme.dart';

class BottomVector extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();


    // Path number 1


    paint.color = AppColors.vectorsBackground;
    path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(0, size.height, 0, 0, 0, 0);
    path.cubicTo(size.width * 0.75, size.height * 0.11, size.width * 1.02, size.height * 0.39, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height, 0, size.height);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
