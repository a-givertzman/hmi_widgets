import 'package:flutter/painting.dart';
/// A path that can be drawn with certain paint.
/// 
/// Base interface for declatative canvas drawing.
abstract class CanvasItem {
  ///
  /// A path along which the item is drawn.
  Path path(Size size);
  ///
  /// Style of drawing.
  Paint get paint;
}