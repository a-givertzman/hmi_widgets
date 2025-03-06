part of '../circular_value_indicator.dart';
///
class _SectorIndicatorWidget extends StatelessWidget {
  final double _angle;
  final double _strokeWidth;
  final Color _color;
  final double? _beginning;
  final double? _ending;
  final double? _padding;
  final double _size;
  final RelativeValue _relativeValue;
  ///
  const _SectorIndicatorWidget({
    required double strokeWidth,
    required Color color,
    required double parentSize,
    required RelativeValue relativeValue,
    double angle = 0,
    double? beginning,
    double? ending,
    double? padding,
  }) :
    _angle = angle,
    _size = parentSize * 0.85,
    _relativeValue = relativeValue,
    _padding = padding,
    _ending = ending,
    _beginning = beginning,
    _color = color,
    _strokeWidth = strokeWidth;
  //
  @override
  Widget build(BuildContext context) {
    if (_ending != null && _beginning != null) {
      final endingRelative = _relativeValue.relative(_ending);
      final beginningRelative = _relativeValue.relative(_beginning);
      final paddingRelative = _relativeValue.relative(_padding);
      return _SizedIndicatorWidget(
        size: _size,
        value: endingRelative - beginningRelative - paddingRelative,
        strokeWidth: _strokeWidth,
        angle: _angle + 360 * beginningRelative,
        color: _color,
      );
    } else {
      return const SizedBox.shrink(); 
    }
  }
}
