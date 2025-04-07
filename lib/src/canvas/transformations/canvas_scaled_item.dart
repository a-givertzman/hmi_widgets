import 'dart:ui';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Drawing, scaled from its original size.
class CanvasScaledItem implements CanvasItem {
  final CanvasItem _item;
  final Offset _scaling;
  ///
  /// Drawing, scaled from its original size.
  /// 
  /// -[scaling] - scale factors along OX and OY.
  /// 
  /// Example:
  /// ```dart
  /// CanvasItemsPainter(
  ///   items: [
  ///     CanvasPoint(...)
  ///       .scale(2),
  ///   ],
  /// );
  /// ```
  /// or
  /// ```dart
  /// CanvasItemsPainter(
  ///   items: [
  ///     CanvasScaledItem(
  ///       CanvasRect(...),
  ///       2
  ///     ),
  ///   ],
  /// );
  /// ```
  const CanvasScaledItem(
    CanvasItem item, {
    required Offset scaling,
  }) :
    _scaling = scaling,
    _item = item;
  //
  @override
  Path path(Size size) {
    final transformationMatrix =  Matrix4.identity()
      ..scale(_scaling.dx, _scaling.dy);
    return _item.path(size).transform(transformationMatrix.storage);
  }  
  //
  @override
  Paint get paint => _item.paint;
}