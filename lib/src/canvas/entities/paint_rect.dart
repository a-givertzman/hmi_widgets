import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/paint_item_dimension.dart';
///
/// Line ([PaintRect]) draw direction
enum PaintLineDirection {
  /// Line will be drawn parallelry with OY
  vertical,
  /// Line will be drawn parallelry with OX
  horizontal,
  /// Neither of the rest.
  undefined,
}
///
/// Displays rect on canvas.
class PaintRect implements PaintItem {
  final Color _color;
  final double _strokeWidth;
  final PaintItemDimension _width;
  final PaintLineDirection _direction;
  ///
  /// Displays rect on canvas.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintRect(...),
  ///   ],
  /// );
  /// ```
  const PaintRect({
    required Color color,
    required double strokeWidth,
    PaintItemDimension width = const PaintItemDimension.sizedFromCanvas(),
    PaintLineDirection direction = PaintLineDirection.undefined,
  }) : 
    _strokeWidth = strokeWidth,
    _width = width,
    _color = color,
    _direction = direction;
  //
  @override
  Path path(Size size) {
    final lineLength = switch(_width) {
      ValueSizedDimension(value:final length) => length,
      CanvasSizedDimension() => switch(_direction) {
        PaintLineDirection.horizontal 
        || PaintLineDirection.undefined => size.width,
        PaintLineDirection.vertical => size.height,
      },
    };
    final sizing = switch(_direction) {
      PaintLineDirection.horizontal 
      || PaintLineDirection.undefined => Offset(lineLength, _strokeWidth),
      PaintLineDirection.vertical => Offset(_strokeWidth, lineLength),
    };
    final translation = switch(_direction) {
      PaintLineDirection.horizontal 
      || PaintLineDirection.undefined => Offset(0.0, -_strokeWidth/2),
      PaintLineDirection.vertical => Offset(-_strokeWidth/2, 0.0),
    };
    return Path()
      ..moveTo(0.0, 0.0)
      ..addRect(Rect.fromLTWH(translation.dx, translation.dy, sizing.dx, sizing.dy));
  }
  //
  @override
  Paint get brush => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}