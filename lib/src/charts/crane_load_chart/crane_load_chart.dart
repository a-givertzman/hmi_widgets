import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_cache.dart';
import 'crane_load_chart_legend_widget.dart';
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
  final Color? _gridColor;
  final GridStyle? _gridType;
  final double _pointSize;
  final double _legendWidth;
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
    Color? gridColor,
    GridStyle? gridType,
    required SwlDataCache swlDataCache,
    required double legendWidth,
  }) : 
    _swlIndexStream = swlIndexStream,
    _xAxisValue = xAxisValue,
    _yAxisValue = yAxisValue,
    _showGrid = showGrid,
    _swlDataCache = swlDataCache,  
    _axisColor = axisColor,
    _gridColor = gridColor,
    _gridType = gridType,
    _pointSize = pointSize,
    _legendWidth = legendWidth,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<CraneLoadChart> createState() => _CraneLoadChartState(
    swlDataCache: _swlDataCache,
    swlIndexStream: _swlIndexStream,
    axisColor: _axisColor,
    gridColor: _gridColor,
    gridType: _gridType,
    pointSize: _pointSize,
    rawWidth: _swlDataCache.rawWidth,
    rawHeight: _swlDataCache.rawHeight,
    xAxisValue: _xAxisValue,
    yAxisValue: _yAxisValue,
    xScale: _swlDataCache.rawWidth / _swlDataCache.width,
    yScale: _swlDataCache.rawHeight / _swlDataCache.height,
    legendWidth: _legendWidth,
    showGrid: _showGrid,
  );
}
///
///
class _CraneLoadChartState extends State<CraneLoadChart> {
  static final _log = const Log('_CraneLoadChartState')..level = LogLevel.debug;
  final Stream<DsDataPoint<int>>? _swlIndexPointStream;
  late final Stream<int>? _swlIndexStream;
  final Map<int, String> _xAxis;
  final Map<int, String> _yAxis;
  final double _pointSize;
  final Color? _axisColor;
  final Color? _gridColor;
  final GridStyle? _gridType;
  final SwlDataCache _swlDataCache;
  final double _legendWidth;
  final bool _showGrid;
  int _swlIndex = 0;
  // late Image? _background;
  ///
  _CraneLoadChartState({
    required SwlDataCache swlDataCache,
    required Stream<DsDataPoint<int>>? swlIndexStream,
    required Color? axisColor,
    required Color? gridColor,
    required GridStyle? gridType,
    required double pointSize,
    required double rawWidth,
    required double rawHeight,
    required double xAxisValue,
    required double yAxisValue,
    required double xScale,
    required double yScale,
    required bool showGrid,
    required double legendWidth,
  }) :
  _swlDataCache = swlDataCache,
  _swlIndexPointStream = swlIndexStream,
  _axisColor = axisColor,
  _gridColor = gridColor,
  _gridType = gridType,
  _pointSize = pointSize,
  _xAxis = _buildAxisLabelTexts(rawWidth, xAxisValue, xScale),
  _yAxis = _buildAxisLabelTexts(rawHeight, yAxisValue, yScale),
  _legendWidth = legendWidth,
  _showGrid = showGrid,
  super();
  //
  @override
  void initState() {
    _log.debug('[_CraneLoadChartState.initState] legendData limits: ', _swlDataCache.legendData.limits);
    _log.debug('[_CraneLoadChartState.initState] legendData colors: ', _swlDataCache.legendData.colors);
    _log.debug('[_CraneLoadChartState.initState] legendData names: ', _swlDataCache.legendData.names);
    final swlIndexPointStream = _swlIndexPointStream;
    if (swlIndexPointStream != null) {
      _swlIndexStream = swlIndexPointStream.map((event) {
        _log.debug('_CraneLoadChartState.swlIndexStream.listen] event: ', event);
        _log.debug('_CraneLoadChartState.swlIndexStream.listen] event.status: ', event.status);
        if (event.status == DsStatus.ok) {            
          _swlIndex = event.value;
        }
        return _swlIndex;
      });
    }
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('[_CraneLoadChartState.build]');
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
                  return StreamBuilder<int>(
                    stream: _swlIndexStream,
                    initialData: _swlIndex,
                    builder: (context, snapshot) {
                      final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
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
                          axisColor: _axisColor ?? onSurfaceColor,
                          gridColor: _gridColor ?? onSurfaceColor,
                          gridType: _gridType ?? GridStyle.straight,
                          backgroundColor: widget.backgroundColor,
                          pointSize: _pointSize,
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: StreamBuilder<int>(
              stream: _swlIndexStream,
              initialData: _swlIndex,
              builder: (context, snapshot) {
                return CraneLoadChartLegendWidget(
                  swlDataCache: _swlDataCache,
                  swlIndex: _swlIndex,
                  width: _legendWidth,
                );
              },
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
  //
  @override
  void dispose() {
    super.dispose();
  }
}