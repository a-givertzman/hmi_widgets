import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transformed.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transform_ext.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
import 'package:hmi_widgets/src/canvas/transformations/reference_point.dart';
///
/// Specifies axis, around which the flip will be performed.
enum PaintFlipDirection {
  ///
  /// Flip along horizontal axis.
  horizontal,
  ///
  /// Flip along vertical axis.
  vertical,
  ///
  /// Flip along both vertical and horizontal axes.
  both
}
///
/// Drawing, flipped around some axis.
class PaintFlipped implements PaintItem {
  final PaintItem _item;
  final PaintFlipDirection _direction;
  ///
  /// Drawing, flipped around some axis. You can select an axis with [direction].
  /// 
  ///  - [PaintFlipDirection.horizontal] - Flip along horizontal axis.
  ///  - [PaintFlipDirection.vertical] - Flip along vertical axis.
  ///  - [PaintFlipDirection.both] - Flip along both vertical and horizontal axes.
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
    required PaintFlipDirection direction,
  }) :
    _direction = direction,
    _item = item;
  ///
  /// Grouped drawings, flipped around some axis. You can select an axis with [direction].
  /// [items] will be placed on top of each other, so maybe you'll need to translate some of them first.
  /// 
  ///  - [PaintFlipDirection.horizontal] - Flip along horizontal axis.
  ///  - [PaintFlipDirection.vertical] - Flip along vertical axis.
  ///  - [PaintFlipDirection.both] - Flip along both vertical and horizontal axes.
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
    required PaintFlipDirection direction,
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
      PaintFlipDirection.vertical => const Offset(1.0, -1.0),
      PaintFlipDirection.horizontal => const Offset(-1.0, 1.0),
      PaintFlipDirection.both => const Offset(-1.0, -1.0),
    };
    return PaintTransformed(
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