import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:hmi_widgets/src/canvas/canvas_item_dimension.dart';
///
enum CanvasLineDirection {
  vertical,
  horizontal,
  undefined,
}
///
class CanvasRect implements CanvasItem {
  final Color _color;
  final double _strokeWidth;
  final CanvasItemDimension _width;
  final CanvasLineDirection _direction;
  ///
  const CanvasRect({
    required Color color,
    required double strokeWidth,
    CanvasItemDimension width = const CanvasItemDimension.sizedFromCanvas(),
    CanvasLineDirection direction = CanvasLineDirection.undefined,
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
        CanvasLineDirection.horizontal 
        || CanvasLineDirection.undefined => size.width,
        CanvasLineDirection.vertical => size.height,
      },
    };
    final sizing = switch(_direction) {
      CanvasLineDirection.horizontal 
      || CanvasLineDirection.undefined => Offset(lineLength, _strokeWidth),
      CanvasLineDirection.vertical => Offset(_strokeWidth, lineLength),
    };
    final translation = switch(_direction) {
      CanvasLineDirection.horizontal 
      || CanvasLineDirection.undefined => Offset(0.0, -_strokeWidth/2),
      CanvasLineDirection.vertical => Offset(-_strokeWidth/2, 0.0),
    };
    return Path()
      ..moveTo(0.0, 0.0)
      ..addRect(Rect.fromLTWH(translation.dx, translation.dy, sizing.dx, sizing.dy));
  }
  //
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}