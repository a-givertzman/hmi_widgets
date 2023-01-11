import 'dart:math';

import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/swl/swl_data.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/crane_load_chart/crane_load_point_painter.dart';
import 'package:flutter/material.dart';

/// диаграмма нагрузки крана
/// загружает координаты x, y, положения крана
/// и нагрузочную способность swl из массивов
/// width, height - размеры в пикселах
/// rawWidth, rawHeight - размеры диаграммы в метрах
class CraneLoadChart extends StatefulWidget {
  final Stream<DsDataPoint<int>>? _swlIndexStream;
  final double _width;
  final double _height;
  final double rawWidth;
  final double rawHeight;
  final double _xScale;
  final double _yScale;
  final double _xAxisValue;
  final double _yAxisValue;
  final bool _showGrid;
  final SwlData _swlData;
  final List<double> _swlLimitSet;
  final List<Color> _swlColorSet;
  final Color backgroundColor;
  final Color? _axisColor;
  final double _pointSize;
  ///
  /// [swlLimitSet] Обязательно должен быть отсортирован по возрастанию
  const CraneLoadChart({
    Key? key,
    Stream<DsDataPoint<int>>? swlIndexStream,
    required double width,
    required double height,
    required this.rawWidth,
    required this.rawHeight,
    required double xAxisValue,
    required double yAxisValue,
    bool showGrid = false,
    required SwlData swlData,
    required List<double> swlLimitSet,
    required List<Color> swlColorSet,
    required this.backgroundColor,
    double pointSize = 1.0,
    Color? axisColor,
  }) : 
    _swlIndexStream = swlIndexStream,
    _width = width,
    _height = height,
    _xScale = rawWidth / width,
    _yScale = rawHeight / height,
    _xAxisValue = xAxisValue,
    _yAxisValue = yAxisValue,
    _showGrid = showGrid,
    _swlData = swlData,
    _swlLimitSet = swlLimitSet,
    _swlColorSet = swlColorSet,   
    _axisColor = axisColor, 
    _pointSize = pointSize,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<CraneLoadChart> createState() => _CraneLoadChartState(
    swlIndexStream: _swlIndexStream,
    axisColor: _axisColor,
    pointSize: _pointSize,
  );
}

class _CraneLoadChartState extends State<CraneLoadChart> {
  final Stream<DsDataPoint<int>>? _swlIndexStream;
  static const _debug = true;
  final Map<int, String> _xAxis = {};
  final Map<int, String> _yAxis = {};
  final List<Offset> _points = [];
  final List<Color> _colors = [];
  final double _pointSize;
  final Color? _axisColor;
  late List<double> _swlLimitSet;
  late List<Color> _swlColorSet;
  late bool _showGrid;
  // late Image? _background;
  ///
  _CraneLoadChartState({
    required Stream<DsDataPoint<int>>? swlIndexStream,
    required Color? axisColor,
    required double pointSize,
  }) :
  _swlIndexStream = swlIndexStream,
  _axisColor = axisColor,
  _pointSize = pointSize,
  super();
  ///
  @override
  void initState() {
    _swlLimitSet = widget._swlLimitSet;
    _swlColorSet = widget._swlColorSet;
    _showGrid = widget._showGrid;
    log(_debug, '[_CraneLoadChartState.initState] _swlLimitSet: ', _swlLimitSet);
    log(_debug, '[_CraneLoadChartState.initState] _swlColorSet: ', _swlColorSet);
    Future.wait([
      widget._swlData.x,
      widget._swlData.y,
      widget._swlData.swl,
    ]).then((value) {
      final swlIndexStream = _swlIndexStream;
      if (swlIndexStream != null) {
        _rebuildChart(0, value);
        swlIndexStream.listen((event) {
          log(_debug, '_CraneLoadChartState.swlIndexStream.listen] event: ', event);
          log(_debug, '_CraneLoadChartState.swlIndexStream.listen] event.status: ', event.status);
          if (event.status.name == DsStatus.ok) {
            final index = event.value;
            _rebuildChart(index, value);
          }
        });
      } else {
        _rebuildChart(0, value);
      }
    });
    super.initState();
  }
  ///
  void _rebuildChart(int index, List<List<Object>> value) {
    log(_debug, '_CraneLoadChartState._rebuildChart] index: ', index);
    final x = value[0] as List<double>;
    final y = value[1] as List<double>;
    final swl = value[2][index] as List<double>;
    _renderPoints(x, y, swl);
    if (mounted) setState(() => fillAxis());
  }
  ///
  @override
  Widget build(BuildContext context) {
    log(_debug, '[_CraneLoadChartState.build]');
    // log(_debug, '_CraneLoadChartState.build] count:', count);
    // log(_debug, '_CraneLoadChartState.build] _x.length:', _x.length);
    // log(_debug, '_CraneLoadChartState.build] _y.length:', _y.length);
    // log(_debug, '_CraneLoadChartState.build] _swl.length:', _swl.length);
    // log(_debug, 'points:', _points);
    final size = Size(widget._width, widget._height);
    return SizedBox(
      width: widget._width,
      height: widget._height,
      child: Stack(
        children: [
          RepaintBoundary(
            key: UniqueKey(),
            child: CustomPaint(
              isComplex: true,
              // willChange: false,
              size: size,
              foregroundPainter: CraneLoadPointPainter(
                xAxis: _xAxis,
                yAxis: _yAxis,
                showGrid: _showGrid,
                points: _points,
                colors: _colors,
                size: size,
                axisColor: _axisColor ?? Theme.of(context).colorScheme.primary,
                backgroundColor: widget.backgroundColor,
                pointSize: _pointSize,
              ),
            ),
          ),
          for (int i = 0; i < widget._swlLimitSet.length; i++) Positioned(
            top: i * 24 + 8,
            right: 0,
            child: Container(
              width: 64,
              color: widget._swlColorSet[i],
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${widget._swlLimitSet[i]}',
                textAlign: TextAlign.center,
                // textScaleFactor: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
  ///
  void fillAxis() {
    final xCount = (widget.rawWidth / widget._xAxisValue).round();
    final yCount = (widget.rawHeight / widget._yAxisValue).round();
    for (int i = 0; i < xCount; i++) {
      final rawDx = i * widget._xAxisValue;
      final dx = (rawDx / widget._xScale).round();
      _xAxis[dx] = '${rawDx.round()}';
    }
    for (int i = 0; i < yCount; i++) {
      final rawDy = i * widget._yAxisValue;
      final dy = (rawDy / widget._yScale).round();
      _yAxis[dy] = '${rawDy.round()}';
    }
  }
  ///
  void _renderPoints(List<double> x, List<double> y, List<double> swl) {
    final count = max(max(x.length, y.length), swl.length);
    _colors.clear();
    _points.clear();
    for (int i = 0; i < count; i++) {
      final dx = x[i] / widget._xScale;
      final dy = widget._height - y[i] / widget._yScale;
      final swlColor = _swlColor(swl[i]);
      _colors.add(swlColor);
      _points.add(Offset(dx, dy));
    }
  }
  Color _swlColor(double swl) {
    final colorIndex = _swlLimitSet.lastIndexWhere((swlElement) {
      return swlElement <= swl;
    });
    return _swlColorSet[colorIndex < 0 ? 0 : colorIndex];
  }
}
