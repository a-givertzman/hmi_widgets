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
  ///       item: PaintRect(...),
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