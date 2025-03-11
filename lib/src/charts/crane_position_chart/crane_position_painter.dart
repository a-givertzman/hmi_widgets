import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'crane_position_chart.dart';
///
class CranePositionPainter extends CustomPainter {
  static const _log = Log('CranePositionPainter');
  final DrawingController _drawingController;
  final int code;
  final Size size;
  final Color _indicatorColor;
  final Color _alarmIndicatorColor;
  final Color _invalidColor;
  ///
  CranePositionPainter({
    required DrawingController drawingController,
    required Color indicatorColor, 
    required Color alarmIndicatorColor,
    required Color invalidColor,
    required this.size,
  }) : 
    _alarmIndicatorColor = alarmIndicatorColor, 
    _indicatorColor = indicatorColor,
    _invalidColor = invalidColor,
    _drawingController = drawingController,
    code = Random().nextInt(1000),
    super(repaint: drawingController);
  //
  @override
  void paint(Canvas canvas, Size size) {
    _log.debug('[.paint]');
    final Color verticalLineColor;
    if (_drawingController.isXValid) {
      verticalLineColor = _drawingController.swlProtection 
        ? _alarmIndicatorColor 
        : _indicatorColor;
    } else {
      verticalLineColor = _invalidColor;
    }
    _drawLine(
      canvas, 
      Offset(_drawingController.point.dx, 0), 
      Offset(_drawingController.point.dx, size.height),
      verticalLineColor,
    );
    final Color horizontalLineColor;
    if (_drawingController.isYValid) {
      horizontalLineColor = _drawingController.swlProtection 
        ? _alarmIndicatorColor 
        : _indicatorColor;
    } else {
      horizontalLineColor = _invalidColor;
    }
    _drawLine(
      canvas, 
      Offset(0, size.height - _drawingController.point.dy),
      Offset(size.width, size.height - _drawingController.point.dy),
      horizontalLineColor,
    );
    final pointLocation = Offset(_drawingController.point.dx, size.height - _drawingController.point.dy);
    if(_drawingController.swlProtection) {
      _drawPoint(
        canvas, 
        pointLocation, 
        _drawingController.isSwlProtectionValid 
          ? _alarmIndicatorColor
          : _invalidColor, 
        10.0,
      );
    }
    _drawPoint(
      canvas, 
      pointLocation, 
      _drawingController.isSwlProtectionValid 
        ? _indicatorColor 
        : _invalidColor,
      5.0,
    );
  }
  ///
  void _drawLine(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    canvas.drawLine(start, end, paint);
  }
  ///
  void _drawPoint(Canvas canvas, Offset location, Color color, double strokeWidth) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawPoints(
      PointMode.points, 
      [location], 
      paint,
    );
  }
  //
  @override
  bool shouldRepaint(covariant CranePositionPainter oldDelegate) {
    return (oldDelegate.code != code) || (oldDelegate.size != size);
  }
}
