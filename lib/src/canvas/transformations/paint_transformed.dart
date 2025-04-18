import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transformation.dart';
///
/// Transforms drawing around specified point
class PaintTransformed implements PaintItem {
  final PaintItem _child;
  final List<PaintTransformation> _transformations;
  ///
  /// Transforms drawing around specified [refPoint].
  /// 
  /// - [child] - item to be transformed
  /// - [transformations] - transformations to be applied to the [child]
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintTransform(
  ///       child: PaintRect(...),
  ///       transformations: [
  ///         TransformationAbsolute.translate(
  ///           translation: Offset(10, 10),
  ///           refPoint: ReferencePoint.center(),
  ///         ),
  ///         TransformationRelative.scale(
  ///           scaling: Offset(6, 2),
  ///           refPoint: ReferencePoint.topLeft(),
  ///         ),
  ///       ],
  ///     );
  ///   ],
  /// );
  /// ```
  const PaintTransformed({
    required PaintItem child,
    required List<PaintTransformation> transformations,
  }) :
    _child = child,
    _transformations = transformations;
  /// 
  /// Transforms drawing around specified [refPoint].
  /// 
  /// - [children] - items to be transformed. [children] will be placed on top of each other, so maybe you'll need to translate some of them first;
  /// - [transformations] - transformations to be applied to the [children];
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintTransform.many(
  ///       children: [
  ///         PaintRect(...),
  ///         PaintPoint(...),
  ///       ],
  ///       transformations: [
  ///         TransformationAbsolute.translate(
  ///           translation: Offset(10, 10),
  ///           refPoint: ReferencePoint.center(),
  ///         ),
  ///         TransformationRelative.scale(
  ///           scaling: Offset(6, 2),
  ///           refPoint: ReferencePoint.topLeft(),
  ///         ),
  ///       ],
  ///     );
  ///   ],
  /// );
  /// ```
  factory PaintTransformed.many({
    required List<PaintItem> children,
    required List<PaintTransformation> transformations,
  }) => PaintTransformed(
    child: PaintJoined(
      children
        .map((child) => (child, Offset.zero))
        .toList(),
    ),
    transformations: transformations,
  );
  //
  @override
  Path path(Size size) {
    return _transformations.fold<PaintItem>(
      _child,
      (item, transformation) => transformation.transform(item, size)
    ).path(size);
  }
  //
  @override
  Paint get brush => _child.brush;
}
