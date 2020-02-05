import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  final Color first;
  final Color second;
  final Color background;

  Painter({
    @required this.first,
    @required this.second,
    @required this.background,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(
      Rect.fromLTRB(0, 0, width, height),
    );
    paint.color = background;
    canvas.drawPath(mainBackground, paint);

    Path ovalPathRight = Path();
    Path ovalPathLeft = Path();

    ovalPathRight.moveTo(0, height * 0.2);
    ovalPathRight.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);
    ovalPathRight.quadraticBezierTo(
        width * 0.58, height * 0.8, width * 0.1, height);
    ovalPathRight.lineTo(0, height);
    ovalPathRight.close();

    ovalPathLeft.moveTo(height / 2, 0);
    ovalPathLeft.quadraticBezierTo(
        width * 0.18, height * 0.5, width * 1.5, height * 0.8);
    ovalPathLeft.quadraticBezierTo(
        width * 9, height * 0.13, width * 1.4, height);
    ovalPathLeft.lineTo(height, 0);
    ovalPathLeft.close();

    paint.color = first;

    canvas.drawPath(ovalPathRight, paint);

    paint.color = second;

    canvas.drawPath(ovalPathLeft, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
