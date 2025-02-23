import 'dart:ui';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
enum CenteringDirection {
  horizontal,
  vertical,
  both,
}
///
class CanvasCenteredItem implements CanvasItem {
  final CenteringDirection _direction;
  final CanvasItem _item;
  ///
  const CanvasCenteredItem(
    CanvasItem item, {
    CenteringDirection direction = CenteringDirection.both,
  }) :
    _item = item,
    _direction = direction;
  //
  @override
  Path path(Size size) {
    final center = size.center(Offset.zero);
    final translation = switch(_direction) {
      CenteringDirection.horizontal => Offset(center.dx, 0.0),
      CenteringDirection.vertical => Offset(0.0, center.dy),
      CenteringDirection.both => center,
    };
    final transformationMatrix = Matrix4.identity()
      ..translate(translation.dx, translation.dy);
    return _item.path(size).transform(transformationMatrix.storage);
  }
  //
  @override
  Paint get paint => _item.paint;

}