import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_cache.dart';
import 'crane_load_point_painter.dart';

/// диаграмма нагрузки крана
/// загружает координаты x, y, положения крана
/// и нагрузочную способность swl из массивов
/// width, height - размеры в пикселах
/// rawWidth, rawHeight - размеры диаграммы в метрах
class CraneLoadChart extends StatefulWidget {
  final Stream<DsDataPoint<int>>? _swlIndexStream;
  final double _xAxisValue;
  final double _yAxisValue;
  final bool _showGrid;
  final SwlDataCache _swlDataCache;
  final Color backgroundColor;
  final Color? _axisColor;
  final double _pointSize;
  ///
  /// [swlLimitSet] Обязательно должен быть отсортирован по возрастанию
  const CraneLoadChart({
    Key? key,
    Stream<DsDataPoint<int>>? swlIndexStream,
    required double xAxisValue,
    required double yAxisValue,
    bool showGrid = false,
    required this.backgroundColor,
    double pointSize = 1.0,
    Color? axisColor, 
    required SwlDataCache swlDataCache,
  }) : 
    _swlIndexStream = swlIndexStream,
    _xAxisValue = xAxisValue,
    _yAxisValue = yAxisValue,
    _showGrid = showGrid,
    _swlDataCache = swlDataCache,  
    _axisColor = axisColor, 
    _pointSize = pointSize,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<CraneLoadChart> createState() => _CraneLoadChartState(
    swlDataCache: _swlDataCache,
    swlIndexStream: _swlIndexStream,
    axisColor: _axisColor,
    pointSize: _pointSize,
    rawWidth: _swlDataCache.rawWidth,
    rawHeight: _swlDataCache.rawHeight,
    xAxisValue: _xAxisValue,
    yAxisValue: _yAxisValue,
    xScale: _swlDataCache.rawWidth / _swlDataCache.width,
    yScale: _swlDataCache.rawHeight / _swlDataCache.height,
  );
}
///
class _CraneLoadChartState extends State<CraneLoadChart> {
  static const _debug = true;
  final Stream<DsDataPoint<int>>? _swlIndexStream;
  final Map<int, String> _xAxis;
  final Map<int, String> _yAxis;
  final double _pointSize;
  final Color? _axisColor;
  final SwlDataCache _swlDataCache;
  late StreamSubscription _swlIndexStreamSubscription;
  late bool _showGrid;
  int _swlIndex = 0;
  // late Image? _background;
  ///
  _CraneLoadChartState({
    required SwlDataCache swlDataCache,
    required Stream<DsDataPoint<int>>? swlIndexStream,
    required Color? axisColor,
    required double pointSize,
    required double rawWidth,
    required double rawHeight,
    required double xAxisValue,
    required double yAxisValue,
    required double xScale,
    required double yScale,
  }) :
  _swlDataCache = swlDataCache,
  _swlIndexStream = swlIndexStream,
  _axisColor = axisColor,
  _pointSize = pointSize,
  _xAxis = _buildAxisLabelTexts(rawWidth, xAxisValue, xScale),
  _yAxis = _buildAxisLabelTexts(rawHeight, yAxisValue, yScale),
  super();
  ///
  @override
  void initState() {
    _showGrid = widget._showGrid;
    log(_debug, '[_CraneLoadChartState.initState] legendData limits: ', _swlDataCache.legendData.limits);
    log(_debug, '[_CraneLoadChartState.initState] legendData colors: ', _swlDataCache.legendData.colors);
    log(_debug, '[_CraneLoadChartState.initState] legendData names: ', _swlDataCache.legendData.names);

    final swlIndexStream = _swlIndexStream;
    if (swlIndexStream != null) {
      _swlIndexStreamSubscription = swlIndexStream.listen((event) {
        log(_debug, '_CraneLoadChartState.swlIndexStream.listen] event: ', event);
        log(_debug, '_CraneLoadChartState.swlIndexStream.listen] event.status: ', event.status);
        if (event.status == DsStatus.ok) {            
          if (mounted) setState(() => _swlIndex = event.value);
        }
      });
    }
    super.initState();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    log(_debug, '[_CraneLoadChartState.build]');
    // log(_debug, '_CraneLoadChartState.build] count:', count);
    // log(_debug, '_CraneLoadChartState.build] _x.length:', _x.length);
    // log(_debug, '_CraneLoadChartState.build] _y.length:', _y.length);
    // log(_debug, '_CraneLoadChartState.build] _swl.length:', _swl.length);
    // log(_debug, 'points:', _points);
    final size = Size(_swlDataCache.width, _swlDataCache.height);
    return SizedBox(
      width: _swlDataCache.width,
      height: _swlDataCache.height,
      child: Stack(
        children: [
          RepaintBoundary(
            key: UniqueKey(),
            child: FutureBuilder(
              future: Future.wait([
                _swlDataCache.points,
                _swlDataCache.swlColors,
              ]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final points = snapshot.data![0] as List<Offset>;
                  final colors = snapshot.data![1] as List<List<Color>>;
                  return CustomPaint(
                    isComplex: true,
                    // willChange: false,
                    size: size,
                    foregroundPainter: CraneLoadPointPainter(
                      xAxis: _xAxis,
                      yAxis: _yAxis,
                      showGrid: _showGrid,
                      points: points,
                      colors: colors[_swlIndex],
                      size: size,
                      axisColor: _axisColor ?? Theme.of(context).colorScheme.primary,
                      backgroundColor: widget.backgroundColor,
                      pointSize: _pointSize,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }
            ),
          ),
          for (int i = 0; i < _swlDataCache.legendData.limits(_swlIndex).length; i++) 
            Positioned(
              top: i * 24 + 8,
              right: 0,
              child: Container(
                width: 64,
                color: _swlDataCache.legendData.colors(_swlIndex).elementAt(i),
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '${_swlDataCache.legendData.names(_swlIndex).elementAt(i)}',
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
  /// Creates names of grid axis anchors  
  static Map<int, String> _buildAxisLabelTexts(double rawSize, double axisValue, double scale) {
    final axis = <int, String>{};
    final count = (rawSize / axisValue).round();
    for (int i = 0; i < count; i++) {
      final rawDx = i * axisValue;
      final dx = (rawDx / scale).round();
      axis[dx] = '${rawDx.round()}';
    }
    return axis;
  }
  ///
  @override
  void dispose() {
    if (_swlIndexStream != null) {
      _swlIndexStreamSubscription.cancel();
    }
    super.dispose();
  }
}