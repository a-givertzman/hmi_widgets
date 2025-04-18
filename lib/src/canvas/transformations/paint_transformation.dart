import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transform_ext.dart';
import 'package:hmi_widgets/src/canvas/transformations/reference_point.dart';
///
abstract interface class PaintTransformation {
  PaintItem transform(PaintItem item, Size size);
}
///
class TransformationRelative implements PaintTransformation {
  final PaintTransformation _transformation;
  final ReferencePoint _refPoint;
  ///
  const TransformationRelative({
    required PaintTransformation transformation,
    required ReferencePoint refPoint,
  }) :
    _refPoint = refPoint,
    _transformation = transformation;
  ///
  factory TransformationRelative.scale({
    required Offset scaling,
    required ReferencePoint refPoint,
  }) => TransformationRelative(
    transformation: _ScaleTransformation(scaling: scaling),
    refPoint: refPoint,
  );
  ///
  factory TransformationRelative.rotate({
    required double rotationRadians,
    required ReferencePoint refPoint,
  }) => TransformationRelative(
    transformation: _RotateTransformation(rotationRadians: rotationRadians),
    refPoint: refPoint,
  );
  ///
  factory TransformationRelative.translate({
    required Offset translation,
    required ReferencePoint refPoint,
  }) => TransformationRelative(
    transformation: _TranslateTransformation(translation: translation),
    refPoint: refPoint,
  );
  //
  @override
  PaintItem transform(PaintItem item, Size size) {
    final point = _refPoint
      .value(
        item
          .path(size)
          .getBounds()
          .size,
      );
    return _transformation.transform(
      item.translate(-point),
      size,
    ).translate(point);
  }
}
///
class TransformationAbsolute implements PaintTransformation {
  final PaintTransformation _transformation;
  final ReferencePoint _refPoint;
  ///
  const TransformationAbsolute({
    required PaintTransformation transformation,
    required ReferencePoint refPoint,
  }) :
    _refPoint = refPoint,
    _transformation = transformation;
  ///
  factory TransformationAbsolute.scale({
    required Offset scaling,
    required ReferencePoint refPoint,
  }) => TransformationAbsolute(
    transformation: _ScaleTransformation(scaling: scaling),
    refPoint: refPoint,
  );
  ///
  factory TransformationAbsolute.rotate({
    required double rotationRadians,
    required ReferencePoint refPoint,
  }) => TransformationAbsolute(
    transformation: _RotateTransformation(rotationRadians: rotationRadians),
    refPoint: refPoint,
  );
  ///
  factory TransformationAbsolute.translate({
    required Offset translation,
    required ReferencePoint refPoint,
  }) => TransformationAbsolute(
    transformation: _TranslateTransformation(translation: translation),
    refPoint: refPoint,
  );
  //
  @override
  PaintItem transform(PaintItem item, Size size) {
    final point = _refPoint.value(size);
    return _transformation.transform(
      item.translate(-point),
      size,
    ).translate(point);
  }
}
///
class _ScaleTransformation implements PaintTransformation {
  final Offset _scaling;
  ///
  const _ScaleTransformation({required Offset scaling}) : _scaling = scaling;
  //
  @override
  PaintItem transform(PaintItem item, Size size) => item.scale(_scaling);
}
///
class _TranslateTransformation implements PaintTransformation {
  final Offset _translation;
  ///
  const _TranslateTransformation({required Offset translation}) : _translation = translation;
  //
  @override
  PaintItem transform(PaintItem item, Size size) => item.translate(_translation);
}
///
class _RotateTransformation implements PaintTransformation {
  final double _rotationRadians;
  ///
  const _RotateTransformation({required double rotationRadians}) : _rotationRadians = rotationRadians;
  @override
  PaintItem transform(PaintItem item, Size size) => item.rotate(_rotationRadians);
}