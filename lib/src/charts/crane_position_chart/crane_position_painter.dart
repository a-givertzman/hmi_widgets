import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'crane_position_chart.dart';
///
class CranePositionPainter extends CustomPainter {
  static const _debug = false;
  final DrawingController _drawingController;
  final int code;
  final Size size;
  ///
  CranePositionPainter({
    required DrawingController drawingController,
    required this.size,
  }) :
    _drawingController = drawingController,
    code = Random().nextInt(1000),
    super(repaint: drawingController);
  //
  @override
  void paint(Canvas canvas, Size size) {
    log(_debug, '[$CranePositionPainter.paint]');
    // final points_ = [
    //   Offset.zero,
    //   Offset(size.width, 0),
    //   Offset(0, size.height),
    //   Offset(size.width, size.height),
    // ];
    // Paint paint = Paint()
    //   ..color = Colors.yellow
    //   ..strokeCap = StrokeCap.round
    //   ..strokeWidth = 5.0;
    // canvas.drawPoints(
    //   PointMode.points, 
    //   points_, 
    //   paint,
    // );

    // paint = Paint();
    //   // ..color = Colors.blueGrey[100]!;
    // canvas.drawRect(
    //   Rect.fromPoints(Offset.zero, Offset(size.width, size.height)), 
    //   paint,
    // );

    // const g1 = LinearGradient(colors: [
    //   Colors.blue,
    //   Colors.green,
    //   Colors.yellow,
    //   Colors.red,
    // ],);
    // Paint paint = Paint()
    //   ..shader = g1.createShader(
    //     Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
    //   );
      // paint = Paint()
      //   ..color = Colors.orange
      //   ..strokeCap = StrokeCap.round
      //   ..strokeWidth = 5.0;
      // canvas.drawPoints(
      //   PointMode.points, 
      //   _points, 
      //   paint,
      // );
    Paint paint = Paint()
      ..color = Colors.yellow
      // ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(_drawingController.point.dx, 0), 
      Offset(_drawingController.point.dx, size.height), 
      paint,
    );
    canvas.drawLine(
      Offset(0, _drawingController.point.dy),
      Offset(size.width, _drawingController.point.dy),
      paint,
    );
    final points = [
      Offset(_drawingController.point.dx, _drawingController.point.dy),
    ];
    paint = Paint()
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    canvas.drawPoints(
      PointMode.points, 
      points, 
      paint,
    );
  }
  //
  @override
  bool shouldRepaint(covariant CranePositionPainter oldDelegate) {
    // return true;
    return (oldDelegate.code != code) || (oldDelegate.size != size);
    // throw UnimplementedError();
  }
}
