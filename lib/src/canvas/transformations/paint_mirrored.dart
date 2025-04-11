import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_item_transformations.dart';
import 'package:hmi_widgets/src/canvas/entities/paint_rect.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
///
/// Drawing, flipped around some axis.
class PaintMirrored implements PaintItem {
  final PaintItem _item;
  final PaintLineDirection _direction;
  ///
  /// Drawing, flipped around some axis. You can select an axis with [direction].
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintMirrored(
  ///       PaintRect(...),
  ///       direction: PaintLineDirection.horizontal,
  ///     ),
  ///   ],
  /// );
  /// ```
  /// or
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///       PaintRect(...).mirror(PaintLineDirection.horizontal),
  ///   ],
  /// );
  /// ```
  const PaintMirrored(
    PaintItem item, {
    required PaintLineDirection direction,
  }) :
    _direction = direction,
    _item = item;
  ///
  /// Grouped drawings, flipped around some axis. You can select an axis with [direction].
  /// [items] will be placed on top of each other, so maybe you'll need to translate some of them first.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintMirrored.many(
  ///       [
  ///         PaintRect(...),
  ///         PaintPoint(...),
  ///       ],
  ///       direction: PaintLineDirection.horizontal,
  ///     ),
  ///   ],
  /// );
  /// ```
  factory PaintMirrored.many(
    List<PaintItem> items, {
    required PaintLineDirection direction,
  }) => PaintMirrored(
    PaintJoined(
      items
        .map((item) => (item, Offset.zero))
        .toList()
    ),
    direction: direction,
  );
  //
  @override
  Path path(Size size) {
    final center = size.center(Offset.zero);
    final scale = switch(_direction) {
      PaintLineDirection.vertical => const Offset(1.0, -1.0),
      PaintLineDirection.horizontal => const Offset(-1.0, 1.0),
      PaintLineDirection.undefined => const Offset(-1.0, -1.0),
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
  Paint get brush => _item.brush;
}