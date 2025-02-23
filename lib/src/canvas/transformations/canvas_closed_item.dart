import 'dart:ui';

import 'package:hmi_widgets/src/canvas/canvas_item.dart';
///
class CanvasClosedItem implements CanvasItem {
  final CanvasItem _item;
  ///
  const CanvasClosedItem(CanvasItem item) :
    _item = item;
  //
  @override
  Path path(Size size) {
    return _item.path(size)..close();
  }  
  //
  @override
  Paint get paint => _item.paint;
}