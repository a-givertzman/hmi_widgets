import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_joined.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_transform_ext.dart';
import 'package:hmi_widgets/src/canvas/transformations/relative_offset.dart';
///
///
enum TransformRelativity {
  canvas,
  item
}
///
///
class PaintTransform implements PaintItem {
  final TransformRelativity _relativity;
  final RefOffset _refPoint;
  final PaintItem _child;
  final PaintItem Function(PaintItem child) _transform;
  ///
  ///
  const PaintTransform({
    required PaintItem child,
    required PaintItem Function(PaintItem child) transform,
    RefOffset refPoint = const RefOffset.topLeft(Offset.zero),
    TransformRelativity relativity = TransformRelativity.item,
  }) :
    _relativity = relativity,
    _refPoint = refPoint,
    _child = child,
    _transform = transform;
  ///
  ///
  factory PaintTransform.many({
    RefOffset refPoint = const RefOffset.topLeft(Offset.zero),
    required List<(PaintItem, Offset)> children,
    required PaintItem Function(PaintItem child) transform,
    TransformRelativity relativity = TransformRelativity.item,
  }) => PaintTransform(
    refPoint: refPoint,
    child: PaintJoined(children),
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
