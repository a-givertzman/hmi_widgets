import 'dart:ui';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// Scales [PaintItem] to the desired length.
class PaintScaledTo implements PaintItem {
  final PaintItem _item;
  final double _targetDimension;
  ///
  /// Scales [item] to the desired [targetDimension].
  /// 
  /// - [targetDimension] - length of longest dimension of target size.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintScaledTo(
  ///       PaintRect(...),
  ///       targetDimension: 100,
  ///     ),
  ///   ],
  /// );
  /// ```
  PaintScaledTo(
    PaintItem item, {
    required double targetDimension,
  }) :
    _targetDimension = targetDimension,
    _item = item;
  ///
  /// Scales group of [items] to the desired [targetDimension].
  /// [items] will be placed on top of each other, so maybe you'll need to translate some of them first.
  /// 
  /// - [targetDimension] - length of longest dimension of target size.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintScaledTo.many(
  ///       [
  ///         PaintRect(...),
  ///         PaintPoint(...),
  ///       ],
  ///       targetDimension: 100,
  ///     ),
  ///   ],
  /// );
  /// ```
  factory PaintScaledTo.many(
    List<PaintItem> items, {
    required double targetDimension,
  }) => PaintScaledTo(
    PaintJoined(
      items
        .map((item) => (item, Offset.zero))
        .toList()
    ),
    targetDimension: targetDimension,
  );
  //
  @override
  Path path(Size size) {
    final pathLength = _item.path(size).getBounds().size.longestSide;
    final scaleFactor = _targetDimension / pathLength;
    return _item
      .scale(Offset(scaleFactor, scaleFactor))
      .path(size);
  }
  //
  @override
  Paint get brush => _item.brush;
}