import 'package:flutter/material.dart';

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 70);
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 1.5, size.height);
    path.quadraticBezierTo(
      controllPoint.dx,
      controllPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
