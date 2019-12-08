import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'Cube.dart';

enum SwitchState { on, off }

class CubeSwitch extends StatefulWidget {
  final double size;
  final SwitchState state;
  final Stream<SwitchState> stream;
  final StreamController<SwitchState> _outputController = StreamController();

  CubeSwitch(this.size, {this.state = SwitchState.off, this.stream});

  @override
  _CubeSwitchState createState() {
    _outputController.add(state);
    return _CubeSwitchState(
        size, state, stream, _outputController);
  }

  Stream<SwitchState> getOutputStream() {
    return _outputController.stream;
  }

}

class _CubeSwitchState extends State<CubeSwitch>
    with SingleTickerProviderStateMixin {
  double size;
  SwitchState _state;
  Stream<SwitchState> stream;
  StreamController<SwitchState> _streamController;
  AnimationController controller;
  Animation<double> animation;

  _CubeSwitchState(this.size, this._state, this.stream, this._streamController);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = _createAnimation(_state);
    if (stream != null) {
      stream.listen((SwitchState newSate) {
        print(newSate);
        _alter();
      });
    }
  }

  void _alter() {
    if (_state == SwitchState.on) {
      _turnOff();
    } else {
      _turnOn();
    }
  }

  void _turnOn() {
    if (_state == SwitchState.on ||
        animation.status == AnimationStatus.forward) {
      print("_turnOn skipped");
      return;
    }
    animation = _createAnimation(SwitchState.on);
    controller.forward();
    print("_turnOn started");
  }

  void _turnOff() {
    if (_state == SwitchState.off ||
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
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _state = finalState;
          _streamController.add(_state);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Cube(size, animation.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
