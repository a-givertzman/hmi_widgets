import 'dart:ui';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// Scales [PaintItem] to the desired length.
class PaintTargetScaled implements PaintItem {
  final PaintItem _item;
  final double _targetDimention;
  ///
  /// Scales [item] to the desired [targetDimention].
  /// 
  /// - [targetDimention] - length of longest dimention of target size.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintTargetScaled(
  ///       PaintRect(...),
  ///       targetDimention: 100,
  ///     ),
  ///   ],
  /// );
  /// ```
  PaintTargetScaled(
    PaintItem item, {
    required double targetDimention,
  }) :
    _targetDimention = targetDimention,
    _item = item;
  ///
  /// Scales group of [items] to the desired [targetDimention].
  /// [items] will be placed on top of each other, so maybe you'll need to translate some of them first.
  /// 
  /// - [targetDimention] - length of longest dimention of target size.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintTargetScaled.many(
  ///       [
  ///         PaintRect(...),
  ///         PaintPoint(...),
  ///       ],
  ///       targetDimention: 100,
  ///     ),
  ///   ],
  /// );
  /// ```
  factory PaintTargetScaled.many(
    List<PaintItem> items, {
    required double targetDimention,
  }) => PaintTargetScaled(
    PaintJoined(
      items
        .map((item) => (item, Offset.zero))
        .toList()
    ),
    targetDimention: targetDimention,
  );
  //
  @override
  Path path(Size size) {
    final pathLength = _item.path(size).getBounds().size.longestSide;
    final scaleFactor = _targetDimention / pathLength;
    return _item
      .scale(Offset(scaleFactor, scaleFactor))
      .path(size);
  }
  //
  @override
  Paint get brush => _item.brush;
}