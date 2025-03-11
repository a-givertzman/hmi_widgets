import 'dart:ui';

import 'package:hmi_widgets/src/canvas/canvas_item.dart';
///
class CanvasCombinedItem implements CanvasItem {
  final CanvasItem _item1;
  final CanvasItem _item2;
  final PathOperation _operation;
  final Paint? _paint;
  ///
  const CanvasCombinedItem(
    CanvasItem item1, CanvasItem item2, {
    required PathOperation operation,
    Paint? paint,
  }) :
    _item1 = item1,
    _item2 = item2,
    _paint = paint,
    _operation = operation;
  //
  @override
  Path path(Size size) {
    return Path.combine(_operation, _item1.path(size), _item2.path(size));
  }  
  //
  @override
  Paint get paint => _paint ?? _item1.paint;
}