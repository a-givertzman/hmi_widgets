import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transform_ext.dart';
import 'package:hmi_widgets/src/canvas/transformations/reference_point.dart';
///
/// Each transformation can be applied relatively either to canvas or to item.
enum TransformRelativity {
  canvas,
  item
}
///
/// Transform drawing around specified point
class PaintTransform implements PaintItem {
  final TransformRelativity _relativity;
  final ReferencePoint _refPoint;
  final PaintItem _child;
  final PaintItem Function(PaintItem child) _transform;
  ///
  /// Transform drawing around specified [refPoint].
  /// 
  /// - [child] - item to be transformed
  /// - [transform] - transformations to be applied to the [child]
  /// - [refPoint] - point relative to which the [transform]ations will be applied
  /// - [relativity] - relativity of the [refPoint]. It can be relative to canvas or to the [child] itself.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintTransform(
  ///       refPoint: ReferencePoint.center(Offset(5, 10)),
  ///       relativity: TransformRelativity.item,
  ///       child: PaintRect(...),
  ///       transform: (child) => child
  ///         .rotate(...)
  ///         .scale(...)
  ///         .translate(...),
  ///     );
  ///   ],
  /// );
  /// ```
  const PaintTransform({
    required PaintItem child,
    required PaintItem Function(PaintItem child) transform,
    ReferencePoint refPoint = const ReferencePoint.topLeft(Offset.zero),
    TransformRelativity relativity = TransformRelativity.item,
  }) :
    _relativity = relativity,
    _refPoint = refPoint,
    _child = child,
    _transform = transform;
  /// 
  /// Transform drawing around specified [refPoint].
  /// 
  /// - [children] - items to be transformed. [children] will be placed on top of each other, so maybe you'll need to translate some of them first;
  /// - [transform] - transformations to be applied to the [children];
  /// - [refPoint] - point relative to which the [transform]ations will be applied;
  /// - [relativity] - relativity of the [refPoint]. It can be relative to canvas or to the [children] themselves.
  /// 
  /// Example:
  /// ```dart
  /// PaintTransform.many(
  ///   refPoint: ReferencePoint.center(Offset(5, 10)),
  ///   relativity: TransformRelativity.item,
  ///   children: [
  ///     PaintRect(...),
  ///     PaintPoint(...),
  ///   ],
  ///   transform: (child) => child
  ///     .rotate(...)
  ///     .scale(...)
  ///     .translate(...),
  /// );
  /// ```
  factory PaintTransform.many({
    ReferencePoint refPoint = const ReferencePoint.topLeft(Offset.zero),
    required List<PaintItem> children,
    required PaintItem Function(PaintItem child) transform,
    TransformRelativity relativity = TransformRelativity.item,
  }) => PaintTransform(
    refPoint: refPoint,
    child: PaintJoined(
      children
        .map((child) => (child, Offset.zero))
        .toList(),
    ),
    transform: transform,
  );
  //
  @override
  Path path(Size size) {
    final point = switch(_relativity) {
      TransformRelativity.canvas => _refPoint.value(size),
      TransformRelativity.item => _refPoint
        .value(
          _child
            .path(size)
            .getBounds()
            .size,
        ),
    };
    return _transform(
        _child.translate(-point)
      )
      .translate(point)
      .path(size);
  }
  //
  @override
  Paint get brush => _child.brush;
}
