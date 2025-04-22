import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
///
/// SVG drawing from its markup.
class PaintSvg implements PaintItem {
  final String _svgMarkup;
  final Color _color;
  final PaintingStyle _style;
  ///
  /// SVG drawing from its [svgMarkup].
  /// 
  /// Example:
  /// ```dart
  /// final testSvg = await File('test.svg').readAsString();
  /// PaintItems(
  ///   items: [
  ///     PaintRect(
  ///        svgMarkup: testSvg,
  ///        ...
  ///     ),
  ///   ],
  /// );
  /// ```
  PaintSvg({
    required String svgMarkup,
    required Color color,
    required PaintingStyle style,
  }) :
    _style = style,
    _color = color,
    _svgMarkup = svgMarkup;
  //
  @override
  Paint get brush => Paint()
    ..style = _style
    ..color = _color
    ..isAntiAlias = true;
  //
  @override
  Path path(Size size) => parseSvgPath(_svgMarkup);
}