import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Drawing, rotated around its center.
class PaintRotated implements PaintItem {
  final PaintItem _item;
  final double _rotationRadians;
  ///
  /// Drawing, rotated around its center.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintRotated(
  ///       PaintRect(...),
  ///       rotationRadians: pi/2,
  ///     ),
  ///   ],
  /// );
  /// ```
  /// or
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintPoint(...)
  ///       .rotate(pi/2),
  ///   ],
  /// );
  /// ```
  const PaintRotated(
    PaintItem item, {
    required double rotationRadians,
  }) :
    _rotationRadians = rotationRadians,
    _item = item;
  ///
  /// Grouped drawings, rotated around its center.
  /// [items] will be placed on top of each other, so maybe you'll need to translate some of them first.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintRotated.many(
  ///       [
  ///         PaintRect(...),
  ///         PaintPoint(...),
  ///       ],
  ///       rotationRadians: pi/2,
  ///     ),
  ///   ],
  /// );
  /// ```
  factory PaintRotated.many(
    List<PaintItem> items, {
    required double rotationRadians,
  }) => PaintRotated(
    PaintJoined(
      items
        .map((item) => (item, Offset.zero))
        .toList()
    ),
    rotationRadians: rotationRadians,
  );
  //
  @override
  Path path(Size size) {
    final transformationMatrix = Matrix4.identity()
      ..rotateZ(-_rotationRadians);
    return _item.path(size).transform(transformationMatrix.storage);
  }
  //
  @override
  Paint get brush => _item.brush;
}