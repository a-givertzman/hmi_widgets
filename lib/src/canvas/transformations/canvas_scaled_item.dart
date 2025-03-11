import 'dart:ui';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
class CanvasScaledItem implements CanvasItem {
  final CanvasItem _item;
  final Offset _scaling;
  ///
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