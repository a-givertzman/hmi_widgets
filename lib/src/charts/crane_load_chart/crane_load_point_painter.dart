import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
enum GridStyle {
  /// Grid will be drawn with straight lines
  straight,
  /// Grid will be drawn with dashed lines
  dashed,
}
///
class CraneLoadPointPainter extends CustomPainter {
  static const _log = Log('CraneLoadPointPainter');
  final Map<int, String> _xAxis;
  final Map<int, String> _yAxis;
  final bool _showGrrid;
  final List<Offset> _points;
  final List<Color> _colors;
  final int code;
  final Size size;
  final Color axisColor;
  final Color _gridColor;
  final GridStyle _gridType;
  final Color _backgroundColor;
  final double _pointSize;
  ///
  CraneLoadPointPainter({
    required Map<int, String> xAxis,
    required Map<int, String> yAxis,
    required bool showGrid,
    required List<Offset> points,
    required List<Color> colors,
    required this.size,
    required this.axisColor,
    required Color gridColor,
    GridStyle gridType = GridStyle.straight,
    required Color backgroundColor,
    double pointSize = 1.0,
  }) :
    _xAxis = xAxis,
    _yAxis = yAxis,
    _showGrrid = showGrid,
    _points = points,
    _colors = colors,
    _backgroundColor = backgroundColor,
    _gridColor = gridColor,
    _gridType = gridType,
    _pointSize = pointSize,
    code = Random().nextInt(1000),
    super();
  //
  @override
  void paint(Canvas canvas, Size size) {
    _log.debug('[.paint] xAxis: $_xAxis | yAxis: $_yAxis');
    _drawBackgroundRect(canvas, size);
    _drawXaxis(canvas, size);
    _drawYaxis(canvas, size);
    _drawPoints(canvas, size, _pointSize);
  }
  ///
  void _drawBackgroundRect(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _backgroundColor;
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)), 
      paint,
    );
  }
  ///
  void _drawXaxis(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gridColor;
    for (final xItem in _xAxis.entries.skip(1)) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: xItem.value,
          style: TextStyle(color: axisColor),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        maxWidth: size.width,
      );
      textPainter.paint(canvas, Offset(xItem.key.toDouble() - textPainter.size.width / 2, size.height * 0.97));
      if (_showGrrid) {
        switch(_gridType) {
          case GridStyle.straight:
            canvas.drawLine(
              Offset(xItem.key.toDouble(), 0), 
              Offset(xItem.key.toDouble(), size.height * 0.965), 
              paint,
            );
            break;
          case GridStyle.dashed:
            _drawDashedLine(
              canvas: canvas,
              p1: Offset(xItem.key.toDouble(), 0),
              p2: Offset(xItem.key.toDouble(), size.height * 0.965),
              pattern: [1, 5],
              paint: paint,
            );
            break;
        }
      }
    }
  }
  ///
  void _drawYaxis(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gridColor;
    for (final yItem in _yAxis.entries.skip(1)) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: yItem.value,
          style: TextStyle(color: axisColor),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        maxWidth: size.height,
      );
      textPainter.paint(canvas, Offset(0, size.height - yItem.key.toDouble() - textPainter.size.height * 0.5));
      if (_showGrrid) {
        switch(_gridType) {
          case GridStyle.straight:
            canvas.drawLine(
              Offset(size.width * 0.04, size.height - yItem.key.toDouble()),
              Offset(size.width, size.height - yItem.key.toDouble()),
              paint,
            );
            break;
          case GridStyle.dashed:
            _drawDashedLine(
              canvas: canvas,
              p1: Offset(size.width * 0.04, size.height - yItem.key.toDouble()),
              p2:  Offset(size.width, size.height - yItem.key.toDouble()),
              pattern: [1, 5],
              paint: paint,
            );
            break;
        }
      }
    }
  }
  ///
  void _drawDashedLine({
    required Canvas canvas,
    required Offset p1,
    required Offset p2,
    required Iterable<double> pattern,
    required Paint paint,
  }) {
    assert(pattern.length.isEven);
    final distance = (p2 - p1).distance;
    final normalizedPattern = pattern.map((width) => width / distance).toList();
    final points = <Offset>[];
    double t = 0;
    int i = 0;
    while (t < 1) {
      points.add(Offset.lerp(p1, p2, t)!);
      t += normalizedPattern[i++];  // dashWidth
      points.add(Offset.lerp(p1, p2, t.clamp(0, 1))!);
      t += normalizedPattern[i++];  // dashSpace
      i %= normalizedPattern.length;
    }
    canvas.drawPoints(PointMode.lines, points, paint);
  }
  ///
  void _drawPoints(Canvas canvas, Size size, double pointSize) {
    Paint paint = Paint();
      // ..style = PaintingStyle.fill;
    for (int i = 0; i < _points.length; i++) {
      paint = Paint()
        ..color = _colors[i]
        ..strokeCap = StrokeCap.round
        ..strokeWidth = pointSize;
      canvas.drawPoints(
        PointMode.points, 
        [_points[i]], 
        paint,
      );
    }
  }
  //
  @override
  bool shouldRepaint(covariant CraneLoadPointPainter oldDelegate) {
    // return true;
    return (oldDelegate.code != code) || (oldDelegate.size != size);
    // throw UnimplementedError();
  }
}
