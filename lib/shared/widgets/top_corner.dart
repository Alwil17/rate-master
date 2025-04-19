import 'package:flutter/material.dart';

class TopVector extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();


    // Path number 1


    paint.color = Color(0xffFFE5FD);
    path = Path();
    path.lineTo(size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width / 4, size.height * 0.89, -0.03, size.height * 0.61, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, 0, size.width, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
