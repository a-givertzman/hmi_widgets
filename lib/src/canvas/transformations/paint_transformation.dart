import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transform_ext.dart';
import 'package:hmi_widgets/src/canvas/transformations/reference_point.dart';
part 'transformation_absolute.dart';
part 'transformation_relative.dart';
/// 
/// Morphing of the item into another.
abstract interface class PaintTransformation {
  ///
  /// Applies transformation to the provided [item].
  /// 
  /// [size] - canvas size.
  PaintItem transform(PaintItem item, Size size);
}
//
class _ScaleTransformation implements PaintTransformation {
  final Offset _scaling;
  //
  const _ScaleTransformation({required Offset scaling}) : _scaling = scaling;
  //
  @override
  PaintItem transform(PaintItem item, Size size) => item.scale(_scaling);
}
//
class _TranslateTransformation implements PaintTransformation {
  final Offset _translation;
  //
  const _TranslateTransformation({required Offset translation}) : _translation = translation;
  //
  @override
  PaintItem transform(PaintItem item, Size size) => item.translate(_translation);
}
//
class _RotateTransformation implements PaintTransformation {
  final double _rotationRadians;
  //
  const _RotateTransformation({required double rotationRadians}) : _rotationRadians = rotationRadians;
  @override
  PaintItem transform(PaintItem item, Size size) => item.rotate(_rotationRadians);
}