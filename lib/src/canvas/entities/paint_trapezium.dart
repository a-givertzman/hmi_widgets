import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
///
/// A classification of trapezium depending on values of bottom angles.
enum TrapeziumType {
  ///
  /// Bottom left ant right angles are not squared
  basic,
  ///
  /// Bottom left angle is squared
  leftSquared,
  ///
  /// Bottom right angle is squared
  rightSquared,
}
/// 
/// [Canvas]-ready drawing of trapezium.
class PaintTrapezium implements PaintItem {
  final Color _color;
  final double _strokeWidth;
  final double _startWidth;
  final double _endWidth;
  final double _height;
  final PaintingStyle _style;
  final TrapeziumType _type;
  /// 
  /// [Canvas]-ready drawing of trapezium.
  /// 
  /// - [color] - coloring of trapezium;
  /// - [startWidth] - length of bottom edge;
  /// - [endWidth] - length of top edge;
  /// - [height] - height of trapezium;
  /// - [strokeWidth] - stroke with for [PaintingStyle.stroke]. Ignored if [style] is [PaintingStyle.fill];
  /// - [style] - how the trapezium should be painted: either stroke or fill;
  /// - [type] - classification of trapezium depending on values of bottom angles.
  /// 
  /// Example:
  /// ```dart
  /// CanvasItemsPainter(
  ///   items: [
  ///     CanvasTrapezium(
  ///       color: Colors.blue,
  ///       startLength: 100,
  ///       endLength: 60,
  ///       height: 50,
  ///     ),
  ///   ],
  /// );
  /// ```
  const PaintTrapezium({
    required Color color,
    required double startWidth,
    required double endWidth,
    required double height,
    double strokeWidth = 2,
    PaintingStyle style = PaintingStyle.fill,
    TrapeziumType type = TrapeziumType.basic,
  }) :
    _strokeWidth = strokeWidth,
    _startWidth = startWidth,
    _endWidth = endWidth,
    _height = height,
    _type = type,
    _style = style,
    _color = color;
  //
  @override
  Path path(Size size) {
    final topRightX = switch(_type) {
      TrapeziumType.basic => _startWidth - (_startWidth - _endWidth)/2,
      TrapeziumType.leftSquared => _endWidth,
      TrapeziumType.rightSquared => _startWidth,
    };
    return Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(_startWidth, 0.0)
      ..lineTo(topRightX, -_height)
      ..lineTo(topRightX - _endWidth, -_height)
      ..close();
  }
  //
  @override
  Paint get brush => Paint()
    ..style = _style
    ..strokeWidth = _strokeWidth
    ..color = _color
    ..isAntiAlias = true;
}