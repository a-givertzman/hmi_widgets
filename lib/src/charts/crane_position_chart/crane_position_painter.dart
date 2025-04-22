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
  final Size _size;
  final Color _indicatorColor;
  final Color _alarmIndicatorColor;
  final Color _invalidColor;
  final double _pointDiameter;
  final double _indicationStrokeWidth;
  final double _labelsOffset;
  final bool _preventLabelOverlap;
  final TextStyle _labelsStyle;
  ///
  CranePositionPainter({
    required DrawingController drawingController,
    required Color indicatorColor, 
    required Color alarmIndicatorColor,
    required Color invalidColor,
    required double pointDiameter,
    required double indicationStrokeWidth,
    required double labelsOffset,
    required TextStyle labelsStyle,
    required Size size,
    required bool preventLabelOverlap,
  }) :
    _size = size,
    _preventLabelOverlap = preventLabelOverlap,
    _alarmIndicatorColor = alarmIndicatorColor, 
    _indicatorColor = indicatorColor,
    _invalidColor = invalidColor,
    _drawingController = drawingController,
    code = Random().nextInt(1000),
    _pointDiameter = pointDiameter,
    _indicationStrokeWidth = indicationStrokeWidth,
    _labelsStyle = labelsStyle,
    _labelsOffset = labelsOffset,
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
      Offset(_drawingController.drawingPoint.dx, 0), 
      Offset(_drawingController.drawingPoint.dx, size.height),
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
      Offset(0, _drawingController.drawingPoint.dy),
      Offset(size.width, _drawingController.drawingPoint.dy),
      horizontalLineColor,
    );
    final pointLocation = Offset(_drawingController.drawingPoint.dx, _drawingController.drawingPoint.dy);
    if(_drawingController.swlProtection) {
      _drawPoint(
        canvas, 
        pointLocation, 
        _drawingController.isSwlProtectionValid 
          ? _alarmIndicatorColor
          : _invalidColor, 
        _pointDiameter + _indicationStrokeWidth*2,
      );
    }
    _drawPoint(
      canvas, 
      pointLocation, 
      _drawingController.isSwlProtectionValid 
        ? _indicatorColor 
        : _invalidColor,
      _pointDiameter,
    );
    final (xLabelPosition, xLabelOffset) = switch(
      _drawingController.drawingPoint.dy < size.height / 2 && _preventLabelOverlap
    ) {
      true => (Offset(_drawingController.drawingPoint.dx, size.height), -_labelsOffset),
      false => (Offset(_drawingController.drawingPoint.dx, 0.0), _labelsOffset),
    };
    _drawText(
      canvas,
      _drawingController.actualPoint.dx.toStringAsFixed(2),
      xLabelPosition,
      xLabelOffset,
      true,
    );
    final (yLabelPosition, yLabelOffset) = switch(
      _drawingController.drawingPoint.dx > size.width / 2 && _preventLabelOverlap
    ) {
      true => (Offset(0.0, _drawingController.drawingPoint.dy), -_labelsOffset),
      false => (Offset(size.width, _drawingController.drawingPoint.dy), _labelsOffset),
    };
    _drawText(
      canvas,
      _drawingController.actualPoint.dy.toStringAsFixed(2),
      yLabelPosition,
      yLabelOffset,
      false,
    );
  }
  ///
  void _drawText(
    Canvas canvas,
    String text,
    Offset location,
    double labelsOffset, [
    bool rotated = false,
  ]) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: _labelsStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    final verticalOffset = switch(_labelsStyle.fontSize) {
      final double fontSize => fontSize / 2,
      null => 10.0,
    };
    textPainter.layout();
    if(rotated) {
      canvas.save();
      canvas.translate(location.dx, location.dy);
      canvas.rotate(-pi/2);
      canvas.translate(-location.dx, -location.dy);
      textPainter.paint(canvas, location - Offset(labelsOffset, verticalOffset));
      canvas.restore();
    } else {
      textPainter.paint(canvas, location - Offset(labelsOffset, verticalOffset));
    }
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
    return (oldDelegate.code != code) || (oldDelegate._size != _size);
  }
}
