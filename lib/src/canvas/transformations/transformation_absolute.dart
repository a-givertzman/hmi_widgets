part of 'paint_transformation.dart';
///
/// [PaintTransformation] with reference point based on canvas dimensions.
class TransformationAbsolute implements PaintTransformation {
  final PaintTransformation _transformation;
  final ReferencePoint _refPoint;
  ///
  /// [PaintTransformation] with reference point based on canvas dimensions.
  const TransformationAbsolute({
    required PaintTransformation transformation,
    required ReferencePoint refPoint,
  }) :
    _refPoint = refPoint,
    _transformation = transformation;
  ///
  /// Scaling with reference point based on canvas dimensions.
  factory TransformationAbsolute.scale({
    required Offset scaling,
    required ReferencePoint refPoint,
  }) => TransformationAbsolute(
    transformation: _ScaleTransformation(scaling: scaling),
    refPoint: refPoint,
  );
  ///
  /// Rotation with reference point based on canvas dimensions.
  factory TransformationAbsolute.rotate({
    required double rotationRadians,
    required ReferencePoint refPoint,
  }) => TransformationAbsolute(
    transformation: _RotateTransformation(rotationRadians: rotationRadians),
    refPoint: refPoint,
  );
  ///
  /// Translation with reference point based on canvas dimensions.
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