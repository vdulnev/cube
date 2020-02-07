import 'dart:math';

import 'package:flutter/widgets.dart';

import 'Cube.dart';

enum SwitchState { on, off }

class CubeSwitchState {
  final CubeState cubeState;
  final SwitchState state;

  CubeSwitchState(this.cubeState, this.state);
}

extension CubeSwitchStateCopy on CubeSwitchState {
  CubeSwitchState setSwitchState(SwitchState switchState) {
    return CubeSwitchState(this.cubeState, switchState);
  }
  CubeSwitchState setCubeState(CubeState cubeState) {
    return CubeSwitchState(cubeState, this.state);
  }
  CubeSwitchState setAngle(double angle) {
    return CubeSwitchState(this.cubeState.setAngle(angle), this.state);
  }
}

class CubeSwitchController {
  _CubeSwitchState _cubeSwitchState;

  void start() {
    _cubeSwitchState.start();
  }
}

class CubeSwitch extends StatefulWidget {
  final CubeSwitchController _controller;
  final CubeSwitchState _cubeSwitchState;

  CubeSwitch(this._cubeSwitchState, this._controller);

  CubeSwitch.fromSize(double size, CubeSwitchController controller): this(CubeSwitchState(CubeState(size, 0), SwitchState.off), controller);

  @override
  _CubeSwitchState createState() {
    return _CubeSwitchState(
        _cubeSwitchState, _controller);
  }
}

class _CubeSwitchState extends State<CubeSwitch>
    with SingleTickerProviderStateMixin {
  final CubeSwitchController cubeSwitchController;
  CubeSwitchState _cubeSwitchState;
  AnimationController controller;
  Animation<double> animation;

  _CubeSwitchState(this._cubeSwitchState, this.cubeSwitchController){
    cubeSwitchController._cubeSwitchState = this;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = _createAnimation(_cubeSwitchState.state);
  }

  void start() {
    if (_cubeSwitchState.state == SwitchState.on) {
      _turnOff();
    } else {
      _turnOn();
    }
  }

  void _turnOn() {
    if (_cubeSwitchState.state == SwitchState.on ||
        animation.status == AnimationStatus.forward) {
      print("_turnOn skipped");
      return;
    }
    animation = _createAnimation(SwitchState.on);
    controller.forward();
    print("_turnOn started");
  }

  void _turnOff() {
    if (_cubeSwitchState.state == SwitchState.off ||
        animation.status == AnimationStatus.reverse) {
      print("_turnOff skipped");
      return;
    }
    animation = _createAnimation(SwitchState.off);
    controller.reverse();
    print("_turnOff started");
  }

  Animation<double> _createAnimation(SwitchState finalState) {
    return Tween<double>(begin: 0.0, end: pi / 2.0).animate(controller)
      ..addListener(() {
        setState(() {_cubeSwitchState = _cubeSwitchState.setAngle(animation.value);});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _cubeSwitchState = _cubeSwitchState.setSwitchState(finalState);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Cube(_cubeSwitchState.cubeState);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
