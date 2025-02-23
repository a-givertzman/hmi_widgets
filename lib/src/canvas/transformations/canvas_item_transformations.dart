import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_centered_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_combined_item.dart';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_mirrored_item.dart';
import 'package:hmi_widgets/src/canvas/entities/canvas_rect.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_rotated_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_scaled_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_transformed_around_point_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/canvas_translated_item.dart';
///
extension CanvasItemTransformations on CanvasItem {
  ///
  CanvasItem rotate(double rotationRadians) => CanvasRotatedItem(
    this,
    rotationRadians: rotationRadians,
  );
  ///
  CanvasItem center([
    CenteringDirection direction = CenteringDirection.both,
  ]) => CanvasCenteredItem(
    this,
    direction: direction,
  );
  ///
  CanvasItem translate(Offset translation) => CanvasTranslatedItem(
    this,
    translation: translation,
  );
  ///
  CanvasItem scale(Offset scaling) => CanvasScaledItem(
    this,
    scaling: scaling,
  );
  ///
  CanvasItem transformAroundPoint(Offset point, {
      Offset scale = const Offset(1.0, 1.0),
      Offset translation = const Offset(0.0, 0.0),
      double rotatationAngleRadians = 0.0,
  }) => CanvasTransformedAroundPointItem(
    this,
    point,
    scale: scale,
    translation: translation,
    rotatationAngleRadians: rotatationAngleRadians,
  );
  ///
  CanvasItem mirror(CanvasLineDirection direction) => CanvasMirroredItem(
    this,
    direction: direction,
  );
  ///
  CanvasItem combine(CanvasItem other, {
    required PathOperation operation,
    Paint? paint,
  }) => CanvasCombinedItem(
    this,
    other,
    operation: operation,
    paint: paint,
  );
}
///
extension CanvasItemIterableTransformations on Iterable<CanvasItem> {
  ///
  Iterable<CanvasItem> rotate(double rotationRadians) => map(
    (item) => item.rotate(rotationRadians),
  );
  ///
  Iterable<CanvasItem> center({
    CenteringDirection direction = CenteringDirection.both,
  }) => map(
    (item) => item.center(direction),
  );
  ///
  Iterable<CanvasItem> translate(Offset translation) => map(
    (item) => item.translate(translation),
  );
  ///
  CanvasItem combine(PathOperation operation, [Paint? paint]) => reduce(
    (combined, item) => combined.combine(
      item,
      operation: operation,
      paint: paint,
    ),
  );
}
