import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
import 'crane_position_painter.dart';
///
class CranePositionChart extends StatefulWidget {
  final Stream<DsDataPoint<double>> _xStream;
  final Stream<DsDataPoint<double>> _yStream;
  final Stream<DsDataPoint<bool>> _swlProtectionStream;
  final Color _color;
  final double _width;
  final double _height;
  final double rawWidth;
  final double rawHeight;
  final double _xScale;
  final double _yScale;
  final double _positionPointDiameter;
  final double _indicationStrokeWidth;
  ///
  const CranePositionChart({
    super.key,
    required Stream<DsDataPoint<double>> xStream,
    required Stream<DsDataPoint<double>> yStream,
    required Stream<DsDataPoint<bool>> swlProtectionStream,
    required double width,
    required double height,
    required Color color,
    required double positionPointDiameter,
    required double indicationStrokeWidth,
    required this.rawWidth,
    required this.rawHeight,
  }) : 
    _xStream = xStream,
    _yStream = yStream,
    _swlProtectionStream = swlProtectionStream,
    _width = width,
    _height = height,
    _color = color,
    _positionPointDiameter = positionPointDiameter,
    _indicationStrokeWidth = indicationStrokeWidth,
    _xScale = rawWidth / width,
    _yScale = rawHeight / height;
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
      final isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_point, _swlProtection);
      _drawingController.isXValid = isPointValid;
    });
    widget._yStream.listen((event) {
      final dy = event.value / widget._yScale;
      _point = Offset(_point.dx, dy);
      final isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_point, _swlProtection);
      _drawingController.isYValid = isPointValid;
    });
    widget._swlProtectionStream.listen((event) {
      _swlProtection = event.value;
      final isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_point, _swlProtection);
      _drawingController.isSwlProtectionValid = isPointValid;
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
          size: size,
          foregroundPainter: CranePositionPainter(
            drawingController: _drawingController,
            size: size,
            indicatorColor: widget._color,
            alarmIndicatorColor: theme.stateColors.alarm,
            invalidColor: theme.stateColors.invalid,
            pointDiameter: widget._positionPointDiameter,
            indicationStrokeWidth: widget._indicationStrokeWidth,
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
  bool _isSwlProtectionValid = true;
  bool _isXValid = true;
  bool _isYValid = true;
  ///
  void add(Offset point, bool swlProtection) {
    _point = point;
    _swlProtection = swlProtection;
    notifyListeners();
  }
  set isSwlProtectionValid(bool value) {
    _isSwlProtectionValid = value;
  }
  set isXValid(bool value) {
    _isXValid = value;
  }
  void set isYValid(bool value) {
    _isYValid = value;
  }
  ///
  Offset get point => _point;
  ///
  bool get swlProtection => _swlProtection;
  ///
  bool get isSwlProtectionValid => _isSwlProtectionValid;
  ///
  bool get isXValid => _isXValid;
  ///
  bool get isYValid => _isYValid;
}
