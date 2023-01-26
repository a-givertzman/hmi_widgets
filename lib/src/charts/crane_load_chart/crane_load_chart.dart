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
  final double _width;
  final double _height;
  final double _rawWidth;
  final double _rawHeight;
  final double _xScale;
  final double _yScale;
  final double _xAxisValue;
  final double _yAxisValue;
  final bool _showGrid;
  final SwlDataCache _swlDataCache;
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
    required double rawWidth,
    required double rawHeight,
    required double xAxisValue,
    required double yAxisValue,
    bool showGrid = false,
    required List<double> swlLimitSet,
    required List<Color> swlColorSet,
    required this.backgroundColor,
    double pointSize = 1.0,
    Color? axisColor, 
    required SwlDataCache swlDataCache,
  }) : 
    _swlIndexStream = swlIndexStream,
    _width = width,
    _height = height,
    _rawWidth = rawWidth,
    _rawHeight = rawHeight,
    _xScale = rawWidth / width,
    _yScale = rawHeight / height,
    _xAxisValue = xAxisValue,
    _yAxisValue = yAxisValue,
    _showGrid = showGrid,
    _swlDataCache = swlDataCache,
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
    rawWidth: _rawWidth,
    rawHeight: _rawHeight,
    xAxisValue: _xAxisValue,
    yAxisValue: _yAxisValue,
    xScale: _xScale,
    yScale: _yScale,
  );
}

///
class _CraneLoadChartState extends State<CraneLoadChart> {
  final Stream<DsDataPoint<int>>? _swlIndexStream;
  static const _debug = true;
  final Map<int, String> _xAxis;
  final Map<int, String> _yAxis;
  final double _pointSize;
  final Color? _axisColor;
  late final Future<List<List<Object>>> _cacheSwlDataFuture;
  late List<double> _swlLimitSet;
  late List<Color> _swlColorSet;
  late bool _showGrid;
  int _swlIndex = 0;
  // late Image? _background;
  ///
  _CraneLoadChartState({
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
  _swlIndexStream = swlIndexStream,
  _axisColor = axisColor,
  _pointSize = pointSize,
  _xAxis = _buildAxisLabelTexts(rawWidth, xAxisValue, xScale),
  _yAxis = _buildAxisLabelTexts(rawHeight, yAxisValue, yScale),
  super();
  ///
  @override
  void initState() {
    _swlLimitSet = widget._swlLimitSet;
    _swlColorSet = widget._swlColorSet;
    _showGrid = widget._showGrid;
    log(_debug, '[_CraneLoadChartState.initState] _swlLimitSet: ', _swlLimitSet);
    log(_debug, '[_CraneLoadChartState.initState] _swlColorSet: ', _swlColorSet);
    _cacheSwlDataFuture = Future.wait([
      widget._swlDataCache.points,
      widget._swlDataCache.swlColors,
    ]).then((value) {
      final swlIndexStream = _swlIndexStream;
      if (swlIndexStream != null) {
        swlIndexStream.listen((event) {
          log(_debug, '_CraneLoadChartState.swlIndexStream.listen] event: ', event);
          log(_debug, '_CraneLoadChartState.swlIndexStream.listen] event.status: ', event.status);
          if (event.status.name == DsStatus.ok) {            
            if (mounted) setState(() => _swlIndex = event.value);
          }
        });
      }
      return value;
    });
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
    final size = Size(widget._width, widget._height);
    return SizedBox(
      width: widget._width,
      height: widget._height,
      child: Stack(
        children: [
          RepaintBoundary(
            key: UniqueKey(),
            child: FutureBuilder(
              future: _cacheSwlDataFuture,
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
                  return CircularProgressIndicator();
                }
              }
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
}
