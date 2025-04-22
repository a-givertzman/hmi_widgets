import 'package:flutter/rendering.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
///
/// Filled circle on a canvas.
class PaintPoint implements PaintItem {
  final Color _color;
  final double _width;
  final Offset _coord;
  ///
  /// Filled circle on a canvas.
  /// - [color] - filling color
  /// - [width] - a diameter of point
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintPoint(...),
  ///   ],
  /// );
  /// ```
  const PaintPoint({
    required Color color,
    required double width,
    Offset coord = const Offset(0.0, 0.0),
  }) : 
    _width = width,
    _color = color,
    _coord = coord;
  //
  @override
  Path path(Size size) => Path()
    ..addOval(
      Rect.fromCircle(
        center: _coord,
        radius: _width,
      ),
    );
  //
  @override
  Paint get brush => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}