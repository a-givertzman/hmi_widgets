import 'dart:ui';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_item_transformations.dart';
import 'package:hmi_widgets/src/canvas/entities/canvas_rect.dart';
///
class CanvasMirroredItem implements CanvasItem {
  final CanvasItem _item;
  final CanvasLineDirection _direction;
  
  ///
  const CanvasMirroredItem(
    CanvasItem item, {
    required CanvasLineDirection direction,
  }) :
    _direction = direction,
    _item = item;
  //
  @override
  Path path(Size size) {
    final center = size.center(Offset.zero);
    final scale = switch(_direction) {
      CanvasLineDirection.vertical => const Offset(1.0, -1.0),
      CanvasLineDirection.horizontal => const Offset(-1.0, 1.0),
      CanvasLineDirection.undefined => const Offset(-1.0, -1.0),
    };
    // final transformationMatrix =  Matrix4.identity()
    //   ..translate(-center.dx, -center.dy)
    //   ..scale(scale.dx, scale.dy)
    //   ..translate(center.dx, center.dy);
    return _item.transformAroundPoint(-center, scale: scale)
      .path(size);
    // return _item.path(size).transform(transformationMatrix.storage);
  }  
  //
  @override
  Paint get paint => _item.paint;
}