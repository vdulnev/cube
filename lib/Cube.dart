import 'dart:math';

import 'package:flutter/material.dart';

class CubeState {
  final double size;
  final double angle;

  CubeState(this.size, this.angle);
  CubeState.newAngle(CubeState oldState, double angle): this(oldState.size, angle);
}

extension CubeStateCopy on CubeState {
  CubeState setAngle(double angle) {
    return CubeState(this.size, angle);
  }
}

class Cube extends StatelessWidget {

  final CubeState _state;

  Cube(this._state);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
      SizedBox(
      width: _state.size,
      height: _state.size,
      child: buildCube(_state.angle),
      ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  CustomPaint buildCube(double angle) {
    return CustomPaint(
        painter: CubePainter(
            Color.fromRGBO(255, 0, 0, 1.0),
            Color.fromRGBO(0, 255, 0, 1.0),
            angle),
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
    return true;
  }
}
