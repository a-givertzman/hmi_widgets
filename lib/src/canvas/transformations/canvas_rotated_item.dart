import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
class CanvasRotatedItem implements CanvasItem {
  final CanvasItem _item;
  final double _rotationRadians;
  ///
  const CanvasRotatedItem(
    CanvasItem item, {
    required double rotationRadians,
  }) :
    _rotationRadians = rotationRadians,
    _item = item;
  //
  @override
  Path path(Size size) {
    final transformationMatrix = Matrix4.identity()
      ..rotateZ(-_rotationRadians);
    return _item.path(size).transform(transformationMatrix.storage);
  }
  //
  @override
  Paint get paint => _item.paint;
}