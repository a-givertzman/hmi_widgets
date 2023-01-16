import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

import 'crane_position_painter.dart';
///
class CranePositionChart extends StatefulWidget {
  final Stream<DsDataPoint<double>> _xStream;
  final Stream<DsDataPoint<double>> _yStream;
  final double _width;
  final double _height;
  final double rawWidth;
  final double rawHeight;
  final double _xScale;
  final double _yScale;
  ///
  const CranePositionChart({
    Key? key,
    required Stream<DsDataPoint<double>> xStream,
    required Stream<DsDataPoint<double>> yStream,
    required double width,
    required double height,
    required this.rawWidth,
    required this.rawHeight,
  }) : 
    _xStream = xStream,
    _yStream = yStream,
    _width = width,
    _height = height,
    _xScale = rawWidth / width,
    _yScale = rawHeight / height,
    super(key: key);
  ///
  @override
  State<CranePositionChart> createState() => _CranePositionChartState();
}


class _CranePositionChartState extends State<CranePositionChart> {
  // static const _debug = true;
  final DrawingController _drawingController = DrawingController();
  Offset _point = Offset.zero;
  ///
  @override
  void initState() {
    widget._xStream.listen((event) {
      final dx = event.value / widget._xScale;
      _point = Offset(dx, _point.dy);
      _drawingController.add(_point);
    });
    widget._yStream.listen((event) {
      final dy = event.value / widget._yScale;
      _point = Offset(_point.dx, dy);
      _drawingController.add(_point);
    });
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    final size = Size(widget._width, widget._height);
    return SizedBox(
      width: widget._width,
      height: widget._height,
      child: CustomPaint(
          // isComplex: true,
          size: size,
          foregroundPainter: CranePositionPainter(
            drawingController: _drawingController,
            size: size,
          ),
        ),
      // RepaintBoundary(
      //   key: Key('$hashCode'),
      //   child: 
      // ),
    );
  }
}

class DrawingController extends ChangeNotifier {
  Offset _point = Offset.zero;
  ///
  void add(Offset point) {
    _point = point;
    notifyListeners();
  }
  ///
  Offset get point => _point;
}
