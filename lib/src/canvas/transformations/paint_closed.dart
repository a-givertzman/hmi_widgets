import 'dart:ui';

import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
///
/// Drawing with closed path (first and last point are connected).
class PaintClosed implements PaintItem {
  final PaintItem _item;
  ///
  /// Drawing with closed path (first and last point are connected).
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintClosed(
  ///       item: PaintRect(...),
  ///     ),
  ///   ],
  /// );
  /// ```
  const PaintClosed(PaintItem item) :
    _item = item;
  ///
  factory PaintClosed.many(List<PaintItem> items) => PaintClosed(
    PaintJoined(
      items
        .map((item) => (item, Offset.zero))
        .toList()
    ),
  );
  //
  @override
  Path path(Size size) {
    return _item.path(size)..close();
  }  
  //
  @override
  Paint get brush => _item.brush;
}