import 'dart:ui';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
class CanvasTransformedAroundPointItem implements CanvasItem {
  final CanvasItem _item;
  final Offset _point;
  final Offset _scale;
  final double _rotatationAngleRadians;
  final Offset _translation;
  ///
  const CanvasTransformedAroundPointItem(
    CanvasItem item,
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
  Paint get paint => _item.paint;
}