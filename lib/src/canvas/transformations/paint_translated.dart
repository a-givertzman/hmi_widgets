import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Drawing, shifted from its original position.
class PaintTranslated implements PaintItem {
  final PaintItem _item;
  final Offset _translation;
  ///
  /// Drawing, shifted from its original position.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintTranslated(
  ///       PaintRect(...),
  ///       translation: Offset(10, 0),
  ///     ),
  ///   ],
  /// );
  /// ```
  /// or
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintRect(...).translate(Offset(10, 0)),
  ///   ],
  /// );
  /// ```
  const PaintTranslated(
    PaintItem item, {
    required Offset translation,
  }) :
    _translation = translation,
    _item = item;
  //
  @override
  Path path(Size size) {
    final transformationMatrix =  Matrix4.identity()
      ..translate(_translation.dx, _translation.dy);
    return _item.path(size).transform(transformationMatrix.storage);
  }  
  //
  @override
  Paint get brush => _item.brush;
}