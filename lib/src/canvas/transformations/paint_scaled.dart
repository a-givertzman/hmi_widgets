import 'dart:ui';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Drawing, scaled from its original size.
class PaintScaled implements PaintItem {
  final PaintItem _item;
  final Offset _scaling;
  ///
  /// Drawing, scaled from its original size.
  /// 
  /// -[scaling] - scale factors along OX and OY.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintScaled(
  ///       PaintRect(...),
  ///       2
  ///     ),
  ///   ],
  /// );
  /// ```
  /// or
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintPoint(...)
  ///       .scale(2),
  ///   ],
  /// );
  /// ```
  const PaintScaled(
    PaintItem item, {
    required Offset scaling,
  }) :
    _scaling = scaling,
    _item = item;
  ///
  factory PaintScaled.many(
    List<PaintItem> items, {
    required Offset scaling,
  }) => PaintScaled(
    PaintJoined(
      items
        .map((item) => (item, Offset.zero))
        .toList()
    ),
    scaling: scaling,
  );
  //
  @override
  Path path(Size size) {
    final transformationMatrix =  Matrix4.identity()
      ..scale(_scaling.dx, _scaling.dy);
    return _item.path(size).transform(transformationMatrix.storage);
  }  
  //
  @override
  Paint get brush => _item.brush;
}