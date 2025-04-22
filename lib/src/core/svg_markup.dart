import 'dart:ui';
import 'package:svg_path_parser/svg_path_parser.dart';

/// 
/// Parses `d` attributes from svg markup into [Path]s
class SvgMarkup {
  final String _svgMarkup;
  /// 
  /// Parses `d` attributes from [svgMarkup] into [Path]s
  const SvgMarkup({
    required String svgMarkup,
  }) : _svgMarkup = svgMarkup;
  ///
  /// Multiple of paths parsed from `d` attributes of `<path>` tags read from svg markup.
  List<Path> paths() {
    final regex = RegExp(
      r'\<\s*path.*d="([. \w]{10,})" .*\>',
      multiLine: true,
    );
    return regex
      .allMatches(_svgMarkup)
      .map((match) => match[1])
      .where((string) => string != null)
      .map((string) => parseSvgPath(string!))
      .toList();
  }
  ///
  /// Single path made of paths parsed from `d` attributes of `<path>` tags read from svg markup.
  Path joinedPaths() => paths().fold(
    Path(),
    (path, component) => path..addPath(component, Offset.zero),
  );
}