import 'package:flutter/painting.dart';
///
abstract class CanvasItem {
  ///
  Path path(Size size);
  ///
  Paint get paint;
}