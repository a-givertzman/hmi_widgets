import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
class CraneLoadPointPainter extends CustomPainter {
  static const _debug = false;
  final Map<int, String> _xAxis;
  final Map<int, String> _yAxis;
  final bool _showGrrid;
  final List<Offset> _points;
  final List<Color> _colors;
  final int code;
  final Size size;
  final Color axisColor;
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
    required Color backgroundColor,
    double pointSize = 1.0,
  }) :
    _xAxis = xAxis,
    _yAxis = yAxis,
    _showGrrid = showGrid,
    _points = points,
    _colors = colors,
    _backgroundColor = backgroundColor,
    _pointSize = pointSize,
    code = Random().nextInt(1000),
    super();
  //
  @override
  void paint(Canvas canvas, Size size) {
    log(_debug, '[$CraneLoadPointPainter.paint]');
    log(_debug, '[$CraneLoadPointPainter.paint] xAxis: ', _xAxis);
    log(_debug, '[$CraneLoadPointPainter.paint] yAxis: ', _yAxis);
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
      ..color = axisColor;
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
        canvas.drawLine(
          Offset(xItem.key.toDouble(), 0), 
          Offset(xItem.key.toDouble(), size.height * 0.965), 
          paint,
        );
      }
    }
  }
  ///
  void _drawYaxis(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = axisColor;
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
        canvas.drawLine(
          Offset(size.width * 0.04, size.height - yItem.key.toDouble()),
          Offset(size.width, size.height - yItem.key.toDouble()),
          paint,
        );
      }
    }
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
