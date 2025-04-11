import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:vector_math/vector_math_64.dart';
/// 
/// Scaled/rotated/translated drawing around specified point
class PaintTransformedAroundPoint implements PaintItem {
  final PaintItem _item;
  final Offset _point;
  final Offset _scale;
  final double _rotatationAngleRadians;
  final Offset _translation;
  ///
  /// Scaled/rotated/translated drawing around specified [point]
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintTransformedAroundPoint(
  ///       PaintRect(...),
  ///       Offset(10.3, 20.2),
  ///       scale: Offset(2, 2),
  ///       translation: Offset(10, 0),
  ///       rotatationAngleRadians = -pi
  ///     ),
  ///   ],
  /// );
  /// ```
  const PaintTransformedAroundPoint(
    PaintItem item,
    Offset point, {
      Offset scale = const Offset(1.0, 1.0),
      Offset translation = const Offset(0.0, 0.0),
      double rotatationAngleRadians = 0.0,
  }) :
    _point = point,
    _scale = scale,
    _translation = translation,
    _rotatationAngleRadians = rotatationAngleRadians,
    _item = item;
  //
  @override
  Path path(Size size) {
    final transformationMatrix =  Matrix4.identity()
      ..translate(-_point.dx, -_point.dy)
      ..rotateZ(_rotatationAngleRadians)
      ..scale(_scale.dx, _scale.dy)
      ..translate(_point.dx+_translation.dx, _point.dy+_translation.dy)
      ;
    return _item.path(size).transform(transformationMatrix.storage);
  }
  //
  @override
  Paint get brush => _item.brush;
}