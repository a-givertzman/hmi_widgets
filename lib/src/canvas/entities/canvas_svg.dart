import 'dart:ui';
import 'package:hmi_widgets/src/canvas/canvas_item.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
///
class CanvasSvg implements CanvasItem {
  final String _svgMarkup;
  final Color _color;
  final PaintingStyle _style;
  ///
  CanvasSvg({
    required String svgMarkup,
    required Color color,
    required PaintingStyle style,
  }) :
    _style = style,
    _color = color,
    _svgMarkup = svgMarkup;
  //
  @override
  Paint get paint => Paint()
    ..style = _style
    ..color = _color
    ..isAntiAlias = true;
  //
  @override
  Path path(Size size) => parseSvgPath(_svgMarkup);
}