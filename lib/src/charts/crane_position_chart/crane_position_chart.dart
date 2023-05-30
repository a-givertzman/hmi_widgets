import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
import 'crane_position_painter.dart';
///
class CranePositionChart extends StatefulWidget {
  final Stream<DsDataPoint<double>> _xStream;
  final Stream<DsDataPoint<double>> _yStream;
  final Stream<DsDataPoint<bool>> _swlProtectionStream;
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
    required Stream<DsDataPoint<bool>> swlProtectionStream,
    required double width,
    required double height,
    required this.rawWidth,
    required this.rawHeight,
  }) : 
    _xStream = xStream,
    _yStream = yStream,
    _swlProtectionStream = swlProtectionStream,
    _width = width,
    _height = height,
    _xScale = rawWidth / width,
    _yScale = rawHeight / height,
    super(key: key);
  //
  @override
  State<CranePositionChart> createState() => _CranePositionChartState();
}

///
class _CranePositionChartState extends State<CranePositionChart> {
  // static const _debug = true;
  final DrawingController _drawingController = DrawingController();
  Offset _point = Offset.zero;
  bool _swlProtection = false;
  //
  @override
  void initState() {
    widget._xStream.listen((event) {
      final dx = event.value / widget._xScale;
      _point = Offset(dx, _point.dy);
      final bool isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_point, _swlProtection,  isPointValid);
    });
    widget._yStream.listen((event) {
      final dy = event.value / widget._yScale;
      _point = Offset(_point.dx, dy);
      final bool isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_point, _swlProtection, isPointValid);
    });
    widget._swlProtectionStream.listen((event) {
      _swlProtection = event.value;
      final bool isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_point, _swlProtection, isPointValid);
    });
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final size = Size(widget._width, widget._height);
    final theme = Theme.of(context);
    return SizedBox(
      width: widget._width,
      height: widget._height,
      child: CustomPaint(
          // isComplex: true,
          size: size,
          foregroundPainter: CranePositionPainter(
            drawingController: _drawingController,
            size: size,
            indicatorColor: Colors.yellow,
            alarmIndicatorColor: theme.stateColors.alarm,
            invalidColor: theme.stateColors.invalid,
          ),
        ),
      // RepaintBoundary(
      //   key: Key('$hashCode'),
      //   child: 
      // ),
    );
  }
}
///
class DrawingController extends ChangeNotifier {
  Offset _point = Offset.zero;
  bool _swlProtection = false;
  bool _isPointValid = true;
  ///
  void add(Offset point, bool swlProtection, [bool isPointValid = true]) {
    _point = point;
    _swlProtection = swlProtection;
    _isPointValid = isPointValid;
    notifyListeners();
  }
  ///
  Offset get point => _point;
  ///
  bool get swlProtection => _swlProtection;
  ///
  bool get isPointValid => _isPointValid;
}
