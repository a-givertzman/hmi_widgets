import 'dart:math';
import 'package:flutter/material.dart';
///
class CircularFabWidget extends StatefulWidget {
  final Widget _icon;
  final List<Widget> _children;
  final double _buttonSize;
  final int _fwdAnimationDuration;
  final int _revAnimationDuration;
  final double? _radius;
  final ShapeBorder? _shape;
  ///
  const CircularFabWidget({
    Key? key,
    required Widget icon,
    required List<Widget> children,
    double buttonSize = 60.0,
    int fwdAnimationDuration = 120,
    int revAnimationDuration = 50,
    double? radius,
    ShapeBorder? shape,
  }) : 
    _icon = icon,
    _children = children,
    _buttonSize = buttonSize,
    _fwdAnimationDuration = fwdAnimationDuration,
    _revAnimationDuration = revAnimationDuration,
    _radius = radius,
    _shape = shape,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<CircularFabWidget> createState() => _CircularFabWidgetState(
    icon: _icon,
    children: _children,
    buttonSize: _buttonSize,
    fwdAnimationDuration: _fwdAnimationDuration,    
    revAnimationDuration: _revAnimationDuration,
    radius: _radius,
    shape: _shape,
  );
}

///
class _CircularFabWidgetState extends State<CircularFabWidget> with TickerProviderStateMixin {
  final Widget _icon;
  final List<Widget> _children;
  final double _buttonSize;
  final int _fwdAnimationDuration;
  final int _revAnimationDuration;
  final double? _radius;
  final ShapeBorder? _shape;
  late AnimationController _animationController;
  ///
  _CircularFabWidgetState({
    required Widget icon,
    required List<Widget> children,
    required double buttonSize,
    required int fwdAnimationDuration,
    required int revAnimationDuration,
    double? radius,
    ShapeBorder? shape,
  }):
    _icon = icon,
    _children = children,
    _buttonSize = buttonSize,
    _fwdAnimationDuration = fwdAnimationDuration,
    _revAnimationDuration = revAnimationDuration,
    _radius = radius,
    _shape = shape;
  //
  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: _fwdAnimationDuration),
      reverseDuration: Duration(milliseconds: _revAnimationDuration),
      vsync: this,
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final menuButton = FloatingActionButton(
      shape: _shape,
      key: UniqueKey(),
      heroTag: UniqueKey(),
      // elevation: 1.0,
      // splashColor: Colors.black,
      child: SizedBox(
        width: _buttonSize,
        height: _buttonSize,
        child: _icon,
      ),
      onPressed: () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      },
    );
    return Flow(
      delegate: FlowMenuDelegate(
        animationController: _animationController,
        buttonSize: _buttonSize,
        padding: _buttonSize * 0.1,
        radius: _radius,
      ),
      children: [
        ..._children.map<Widget>((child) {
          return buildFab(child);
        }).toList(),
        menuButton,
      ],
    );
  }
  ///
  Widget buildFab(Widget button) {
    return SizedBox(
      width: _buttonSize * 0.95,
      height: _buttonSize * 0.95,
      child: button,
    );
  }
  //
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

///
class FlowMenuDelegate extends FlowDelegate {
  final AnimationController _animationController;
  final double _buttonSize;
  final double _padding;
  final double _radius;
  ///
  const FlowMenuDelegate({
    required AnimationController animationController,
    required double buttonSize,
    required double padding,
    double? radius,
  }) :
    _animationController = animationController,
    _buttonSize = buttonSize,
    _padding = padding,
    _radius = radius ?? buttonSize * 2,
    super(repaint: animationController);
  //
  @override
  void paintChildren(FlowPaintingContext context) {
    // final size = context.size;
    const xStart = 0; //size.width - _buttonSize;
    const yStart = 0; //size.height - _buttonSize;
    final count = context.childCount;
    for (int i = 0; i < count; i++) {
      final isLastItem = i == count - 1;
      double setValue(double v) => isLastItem ? 0.0 : v;
      final radius = _radius * _animationController.value;
      final alpha = i * pi * 0.5 / (count - 2);
      // final x = setValue(radius * (_buttonSize + _padding) * 0.008 * i);
      final x = xStart + setValue(radius * cos(alpha)) + _padding * 0;
      // final y = setValue(0.0);
      final y = yStart + setValue(radius * sin(alpha))+ _padding * 0;
      context.paintChild(
        i,
        transform: Matrix4.identity()
          ..translate(x, y)
          ..translate(_buttonSize / 2, _buttonSize / 2)
          ..rotateZ(isLastItem 
            ? ((_animationController.value) * pi * 2)
            : 0.0,)
          ..scale(isLastItem 
            ? max(_animationController.value, 0.9)
            : max(_animationController.value, 0.5),)
          ..translate(-_buttonSize / 2, -_buttonSize / 2),
        opacity: isLastItem ? 1.0 : _animationController.value,
      );
    }
  }
  //
  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
