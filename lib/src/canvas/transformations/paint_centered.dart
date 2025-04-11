import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// On wich axis centering is done
enum CenteringDirection {
  ///
  /// Center on OX axis
  horizontal,
  ///
  /// Center on OY axis
  vertical,
  /// 
  /// Absolute center
  both,
}
///
/// Paint element with applied centering.
class PaintCentered implements PaintItem {
  final CenteringDirection _direction;
  final PaintItem _item;
  /// 
  /// Paint element with applied centering.
  /// 
  /// Type of centering can be spesified with [direction].
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintCentered(
  ///       item: PaintPoint(...),
  ///     ),
  ///   ],
  /// );
  /// ```
  /// or
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintPoint(...).center(),
  ///   ],
  /// );
  /// ```
  const PaintCentered(
    PaintItem item, {
    CenteringDirection direction = CenteringDirection.both,
  }) :
    _item = item,
    _direction = direction;
  ///
  factory PaintCentered.many(
    List<PaintItem> items, {
    required CenteringDirection direction,
  }) => PaintCentered(
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
    final translation = switch(_direction) {
      CenteringDirection.horizontal => Offset(center.dx, 0.0),
      CenteringDirection.vertical => Offset(0.0, center.dy),
      CenteringDirection.both => center,
    };
    final transformationMatrix = Matrix4.identity()
      ..translate(translation.dx, translation.dy);
    return _item.path(size).transform(transformationMatrix.storage);
  }
  //
  @override
  Paint get brush => _item.brush;

}