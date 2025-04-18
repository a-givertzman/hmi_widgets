import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transform.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transform_ext.dart';
import 'package:hmi_widgets/src/canvas/entities/paint_rect.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
import 'package:hmi_widgets/src/canvas/transformations/reference_point.dart';
///
/// Drawing, flipped around some axis.
class PaintFlipped implements PaintItem {
  final PaintItem _item;
  final PaintLineDirection _direction;
  ///
  /// Drawing, flipped around some axis. You can select an axis with [direction].
  /// 
  ///  - [PaintLineDirection.horizontal] - horizontal flip
  ///  - [PaintLineDirection.vertical] - vertical flip
  ///  - [PaintLineDirection.undefined] - flip both vertically and horizontally
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintFlipped(
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
  ///       PaintRect(...).flip(PaintLineDirection.horizontal),
  ///   ],
  /// );
  /// ```
  const PaintFlipped(
    PaintItem item, {
    required PaintLineDirection direction,
  }) :
    _direction = direction,
    _item = item;
  ///
  /// Grouped drawings, flipped around some axis. You can select an axis with [direction].
  /// [items] will be placed on top of each other, so maybe you'll need to translate some of them first.
  /// 
  ///  - [PaintLineDirection.horizontal] - horizontal flip
  ///  - [PaintLineDirection.vertical] - vertical flip
  ///  - [PaintLineDirection.undefined] - flip both vertically and horizontally
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintFlipped.many(
  ///       [
  ///         PaintRect(...),
  ///         PaintPoint(...),
  ///       ],
  ///       direction: PaintLineDirection.horizontal,
  ///     ),
  ///   ],
  /// );
  /// ```
  factory PaintFlipped.many(
    List<PaintItem> items, {
    required PaintLineDirection direction,
  }) => PaintFlipped(
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
    final scale = switch(_direction) {
      PaintLineDirection.vertical => const Offset(1.0, -1.0),
      PaintLineDirection.horizontal => const Offset(-1.0, 1.0),
      PaintLineDirection.undefined => const Offset(-1.0, -1.0),
    };
    return PaintTransform(
      refPoint: ReferencePoint.center(),
      relativity: TransformRelativity.item,
      child: _item,
      transform: (child) => child.scale(scale),
    ).path(size);
  }  
  //
  @override
  Paint get brush => _item.brush;
}