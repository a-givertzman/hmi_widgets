part of '../circular_value_indicator.dart';
///
class _SizedIndicatorWidget extends StatelessWidget {
  final double _angle;
  final double _value;
  final double _strokeWidth;
  final double _size;
  final Color? _color;
  final Color? _backgroundColor;
  ///
  const _SizedIndicatorWidget({
    required double value,
    required double strokeWidth,
    required double size,
    double angle = 0,
    Color? color,
    Color? backgroundColor,
  }) :
    _angle = angle,
    _backgroundColor = backgroundColor,
    _color = color,
    _size = size,
    _strokeWidth = strokeWidth,
    _value = value;
  //
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 2 * pi * _angle / 360,
      child: RepaintBoundary(
        key: UniqueKey(),
        child: SizedBox(
          width: _size,
          height: _size,
            child: CircularProgressIndicator(
              backgroundColor: _backgroundColor,
              color: _color,
              value: _value,
              strokeWidth: _strokeWidth,
            ),
        ),
      ),
    );
  }
}