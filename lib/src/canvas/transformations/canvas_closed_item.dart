import 'dart:ui';

import 'package:hmi_widgets/src/canvas/canvas_item.dart';
///
/// Canvas element with closed path (first and last point are connected).
class CanvasClosedItem implements CanvasItem {
  final CanvasItem _item;
  ///
  /// Canvas element with closed path (first and last point are connected).
  /// 
  /// Example:
  /// ```dart
  /// CanvasItemsPainter(
  ///   items: [
  ///     CanvasClosedItem(
  ///       item: CanvasRect(...),
  ///     ),
  ///   ],
  /// );
  /// ```
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