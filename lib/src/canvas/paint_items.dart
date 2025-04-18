import 'package:flutter/rendering.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
///
/// [CustomPainter] that allows to define canvas items declaratively.
class PaintItems extends CustomPainter {
  final Iterable<PaintItem> _items;
  ///
  /// [CustomPainter] that allows to define canvas [items] declaratively.
  /// 
  /// Example:
  /// ```dart
  /// CustomPaint(
  ///   painter: PaintItems(
  ///     items: [
  ///       PaintPoint(...),
  ///       PaintRect(...),
  ///     ],
  ///   ),
  /// );
  /// ```
  const PaintItems({
    super.repaint,
    required Iterable<PaintItem> items,
  }) : _items = items;
  //
  @override
  void paint(Canvas canvas, Size size) {
    for(final item in _items) {
      canvas.drawPath(item.path(size), item.brush);
    }
  }
  //
  @override
  bool shouldRepaint(covariant PaintItems oldDelegate) {
    return !oldDelegate._items.toSet().containsAll(_items);
  }
}