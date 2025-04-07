import 'dart:ui';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Canvas drawing, shifted from its original position.
class CanvasTranslatedItem implements CanvasItem {
  final CanvasItem _item;
  final Offset _translation;
  ///
  /// Canvas drawing, shifted from its original position.
  /// 
  /// Example:
  /// ```dart
  /// CanvasItemsPainter(
  ///   items: [
  ///     CanvasTranslatedItem(
  ///       CanvasRect(...),
  ///       translation: Offset(10, 0),
  ///     ),
  ///   ],
  /// );
  /// ```
  /// or
  /// ```dart
  /// CanvasItemsPainter(
  ///   items: [
  ///     CanvasRect(...).translate(Offset(10, 0)),
  ///   ],
  /// );
  /// ```
  const CanvasTranslatedItem(
    CanvasItem item, {
    required Offset translation,
  }) :
    _translation = translation,
    _item = item;
  //
  @override
  Path path(Size size) {
    final transformationMatrix =  Matrix4.identity()
      ..translate(_translation.dx, _translation.dy);
    return _item.path(size).transform(transformationMatrix.storage);
  }  
  //
  @override
  Paint get paint => _item.paint;
}