import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_centered.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_bool.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_flipped.dart';
import 'package:hmi_widgets/src/canvas/entities/paint_rect.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_rotated.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_scaled.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transformed_around_point.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_translated.dart';
///
/// Extensions for fast chaining of [PaintItem] transformations
/// 
/// Example:
/// ```dart
/// PaintItems(
///   items: [
///     PaintPoint(...)
///       .rotate(...)
///       .transform(..)
///       .scale(..),
///   ],
/// );
extension PaintTransform on PaintItem {
  ///
  PaintItem rotate(double rotationRadians) => PaintRotated(
    this,
    rotationRadians: rotationRadians,
  );
  ///
  PaintItem center([
    CenteringDirection direction = CenteringDirection.both,
  ]) => PaintCentered(
    this,
    direction: direction,
  );
  ///
  PaintItem translate(Offset translation) => PaintTranslated(
    this,
    translation: translation,
  );
  ///
  PaintItem scale(Offset scaling) => PaintScaled(
    this,
    scaling: scaling,
  );
  ///
  PaintItem transformAroundPoint(Offset point, {
      Offset scale = const Offset(1.0, 1.0),
      Offset translation = const Offset(0.0, 0.0),
      double rotatationAngleRadians = 0.0,
  }) => PaintTransformedAroundPoint(
    this,
    point,
    scale: scale,
    translation: translation,
    rotatationAngleRadians: rotatationAngleRadians,
  );
  ///
  PaintItem mirror(PaintLineDirection direction) => PaintFlipped(
    this,
    direction: direction,
  );
  ///
  PaintItem combine(PaintItem other, {
    required PathOperation operation,
    Paint? paint,
  }) => PaintBool(
    [
      this,
      other,
    ],
    operation: operation,
    paint: paint,
  );
}
///
/// Extensions for fast chaining transformations of collections of [PaintItem]
/// 
/// Example:
/// ```dart
/// PaintItems(
///   items: [
///     PaintPoint(...),
///     ...[
///       PaintPoint(...),
///       PaintRect(...),
///     ]
///       .rotate(...)
///       .translate(...)
///       .scale(...)
///       .center(...),
///   ],
/// );
extension PaintsTransform on Iterable<PaintItem> {
  ///
  Iterable<PaintItem> rotate(double rotationRadians) => map(
    (item) => item.rotate(rotationRadians),
  );
  ///
  Iterable<PaintItem> center({
    CenteringDirection direction = CenteringDirection.both,
  }) => map(
    (item) => item.center(direction),
  );
  ///
  Iterable<PaintItem> translate(Offset translation) => map(
    (item) => item.translate(translation),
  );
  ///
  Iterable<PaintItem> scale(Offset scaling) => map(
    (item) => item.scale(scaling),
  );
  ///
  PaintItem combine(PathOperation operation, [Paint? paint]) => reduce(
    (combined, item) => combined.combine(
      item,
      operation: operation,
      paint: paint,
    ),
  );
}
