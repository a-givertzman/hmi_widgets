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
  final Size _size;
  final Size _rawSize;
  final double _xScale;
  final double _yScale;
  final double _positionPointDiameter;
  final double _indicationStrokeWidth;
  final TextStyle _labelsStyle;
  final double _labelsOffset;
  final bool _preventLabelOverlap;
  ///
  CranePositionChart({
    super.key,
    required Stream<DsDataPoint<double>> xStream,
    required Stream<DsDataPoint<double>> yStream,
    required Stream<DsDataPoint<bool>> swlProtectionStream,
    required Size size,
    required Size rawSize,
    required Color color,
    required double positionPointDiameter,
    required double indicationStrokeWidth,
    required TextStyle labelsStyle,
    required double labelsOffset,
    bool preventLabelOverlap = false,
  }) :
    _xStream = xStream,
    _yStream = yStream,
    _size = size,
    _rawSize = rawSize,
    _swlProtectionStream = swlProtectionStream,
    _color = color,
    _positionPointDiameter = positionPointDiameter,
    _indicationStrokeWidth = indicationStrokeWidth,
    _labelsStyle = labelsStyle,
    _labelsOffset = labelsOffset,
    _preventLabelOverlap = preventLabelOverlap,
    _xScale = rawSize.width / size.width,
    _yScale = rawSize.height / size.height;
  //
  @override
  State<CranePositionChart> createState() => _CranePositionChartState();
}

///
class _CranePositionChartState extends State<CranePositionChart> {
  final DrawingController _drawingController = DrawingController();
  Offset _drawingPoint = Offset.zero;
  Offset _actualPoint = Offset.zero;
  bool _swlProtection = false;
  //
  @override
  void initState() {
    widget._xStream.listen((event) {
      final dx = event.value / widget._xScale;
      _drawingPoint = Offset(dx, _drawingPoint.dy);
      _actualPoint = Offset(event.value, _actualPoint.dy);
      final isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_drawingPoint, _actualPoint, _swlProtection);
      _drawingController.isXValid = isPointValid;
    });
    widget._yStream.listen((event) {
      final dy = (widget._rawSize.height - event.value) / widget._yScale;
      _drawingPoint = Offset(_drawingPoint.dx, dy);
      _actualPoint = Offset(_actualPoint.dx, event.value);
      final isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_drawingPoint, _actualPoint, _swlProtection);
      _drawingController.isYValid = isPointValid;
    });
    widget._swlProtectionStream.listen((event) {
      _swlProtection = event.value;
      final isPointValid = event.status != DsStatus.invalid;
      _drawingController.add(_drawingPoint, _actualPoint, _swlProtection);
      _drawingController.isSwlProtectionValid = isPointValid;
    });
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: widget._size.width,
      height: widget._size.height,
      child: CustomPaint(
          size: widget._size,
          foregroundPainter: CranePositionPainter(
            preventLabelOverlap: widget._preventLabelOverlap,
            drawingController: _drawingController,
            size: widget._size,
            indicatorColor: widget._color,
            alarmIndicatorColor: theme.stateColors.alarm,
            invalidColor: theme.stateColors.invalid,
            pointDiameter: widget._positionPointDiameter,
            indicationStrokeWidth: widget._indicationStrokeWidth,
            labelsStyle: widget._labelsStyle,
            labelsOffset: widget._labelsOffset,
          ),
        ),
    );
  }
}
///
class DrawingController extends ChangeNotifier {
  Offset _drawingPoint = Offset.zero;
  Offset _actualPoint = Offset.zero;
  bool _swlProtection = false;
  bool _isSwlProtectionValid = true;
  bool _isXValid = true;
  bool _isYValid = true;
  ///
  void add(Offset drawingPoint, Offset actualPoint, bool swlProtection) {
    _drawingPoint = drawingPoint;
    _actualPoint = actualPoint;
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
  Offset get drawingPoint => _drawingPoint;
  ///
  Offset get actualPoint => _actualPoint;
  ///
  bool get swlProtection => _swlProtection;
  ///
  bool get isSwlProtectionValid => _isSwlProtectionValid;
  ///
  bool get isXValid => _isXValid;
  ///
  bool get isYValid => _isYValid;
}
