part of 'paint_transformation.dart';
///
/// [PaintTransformation] with reference point based on [PaintItem] dimensions.
class TransformationRelative implements PaintTransformation {
  final PaintTransformation _transformation;
  final ReferencePoint _refPoint;
  ///
  /// [PaintTransformation] with reference point based on [PaintItem] dimensions.
  const TransformationRelative({
    required PaintTransformation transformation,
    required ReferencePoint refPoint,
  }) :
    _refPoint = refPoint,
    _transformation = transformation;
  ///
  /// Scalings with reference point based on [PaintItem] dimensions.
  factory TransformationRelative.scale({
    required Offset scaling,
    required ReferencePoint refPoint,
  }) => TransformationRelative(
    transformation: _ScaleTransformation(scaling: scaling),
    refPoint: refPoint,
  );
  ///
  /// Rotation with reference point based on [PaintItem] dimensions.
  factory TransformationRelative.rotate({
    required double rotationRadians,
    required ReferencePoint refPoint,
  }) => TransformationRelative(
    transformation: _RotateTransformation(rotationRadians: rotationRadians),
    refPoint: refPoint,
  );
  ///
  /// Translation with reference point based on [PaintItem] dimensions.
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