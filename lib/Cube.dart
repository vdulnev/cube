import 'dart:math';

import 'package:flutter/material.dart';

class Cube extends StatelessWidget {
  final double size;
  final double angle;

  Cube(this.size, this.angle);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
      SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
          painter: CubePainter(
              Color.fromRGBO(255, 0, 0, 1.0),
              Color.fromRGBO(0, 255, 0, 1.0),
              angle),
        ),
      ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class CubePainter extends CustomPainter {

  Color onColor;
  Color offColor;
  double angle;

  CubePainter(this.onColor, this.offColor, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = offColor;
    Size offSize = Size(size.width * cos(angle), size.height);
    canvas.drawRect(Offset.zero & offSize, paint);
    paint.color = onColor;
    Size onSize = Size(size.width - offSize.width, size.height);
    Offset offOffset = Offset(size.width - onSize.width, 0);
    canvas.drawRect(offOffset & onSize, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
