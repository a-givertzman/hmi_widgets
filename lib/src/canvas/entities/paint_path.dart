import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
///
/// Drawing of some [Path].
class PaintPath implements PaintItem {
  final Path _path;
  final Color _color;
  final PaintingStyle _style;
  final double _strokeWidth;
  ///
  /// Drawing of some [Path].
  /// 
   /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintPath(
  ///       path: Path().addOval(
  ///         Rect.fromCenter(
  ///           center: Offset.zero,
  ///           width: 100,
  ///           height: 100,
  ///         ),
  ///       ),
  ///       color: Colors.blue,
  ///     ),
  ///   ],
  /// );
  /// ```
  const PaintPath({
    required Path path,
    required Color color,
    PaintingStyle style = PaintingStyle.stroke,
    double strokeWidth = 2,
  }) :
    _path = path,
    _color = color,
    _style = style,
    _strokeWidth = strokeWidth;
  //
  @override
  Path path(Size size) => _path;
  //
  @override
  Paint get brush => Paint()
    ..style = _style
    ..color = _color
    ..strokeWidth = _strokeWidth
    ..isAntiAlias = true;
}