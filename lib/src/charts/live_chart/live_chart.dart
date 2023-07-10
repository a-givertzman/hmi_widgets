import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'live_axis.dart';
import 'x_title.dart';
import 'y_title.dart';
///
class LiveChartLinesMarkup {
  final int? _dashLength;
  final int? _dashSpasing;
  final double _strokeWidth;
  final Color? _color;
  ///
  const LiveChartLinesMarkup({
    int? dashLength,
    int? dashSpasing,
    Color? color,
    double strokeWidth = 0.5,
  }) : 
    _dashLength = dashLength,
    _dashSpasing = dashSpasing,
    _strokeWidth = strokeWidth,
    _color = color,
    // XNOR, true if both conditions have same values
    assert(!((dashLength == null) ^ (dashSpasing == null)));

  FlLine toLineData(BuildContext context) => FlLine(
    color: _color ?? Theme.of(context).colorScheme.primary.withOpacity(0.4),
    strokeWidth: _strokeWidth,
    dashArray: _dashLength != null && _dashSpasing != null 
      ? [_dashLength!, _dashSpasing!] 
      : [],
  );
}
///
class LiveChartMarkup {
  final LiveChartLinesMarkup? verticalLines;
  final LiveChartLinesMarkup? horizontalLines;
  ///
  const LiveChartMarkup(this.verticalLines, this.horizontalLines);
}
///
/// Chart that draws multiple signals:
/// - point values taken from [points] Map<String, List<FlSpot>>,
/// - view data for each signal taken from [axesData] Map<String, LiveAxis>.
class LiveChart extends StatelessWidget {
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final double? _yInterval;
  final double? _xInterval;
  final LiveChartMarkup? _markup;
  final Map<String, LiveAxis> _axesData;
  final Map<String, List<FlSpot>> _points;
  ///
  /// Chart that draws multiple signals:
  /// - point values taken from [points] Map<String, List<FlSpot>>,
  /// - view data for each signal taken from [axesData] Map<String, LiveAxis>.
  const LiveChart({
    super.key,
    required double? minX,
    required double? maxX,
    required double? minY,
    required double? maxY,
    required double? yInterval,
    required double? xInterval,
    required LiveChartMarkup? markup,
    required Map<String, LiveAxis> axesData,
    required Map<String, List<FlSpot>> points,
  }) : 
    _minX = minX, 
    _maxX = maxX, 
    _minY = minY, 
    _maxY = maxY, 
    _yInterval = yInterval, 
    _xInterval = xInterval,
    _markup = markup,
    _axesData = axesData,
    _points = points;
  //
  @override
  Widget build(BuildContext context) {
    return LineChart(
      duration: Duration.zero,
      LineChartData(
        minX: _minX,
        maxX: _maxX,
        minY: _minY,
        maxY: _maxY,
        lineBarsData: _lineBarsData,
        clipData: FlClipData.all(),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          horizontalInterval: _yInterval,
          getDrawingHorizontalLine: (_) => _markup?.horizontalLines?.toLineData(context) ?? _line(context),
          verticalInterval: _xInterval,
          getDrawingVerticalLine: (_) => _markup?.verticalLines?.toLineData(context) ?? _line(context),
        ),
        titlesData: _titlesData,
      ),
    );
  }
  ///
  FlLine _line(BuildContext context) => FlLine(
    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
    strokeWidth: 0.5,
  );
  ///
  List<LineChartBarData> get _lineBarsData {
    return _points.entries
      .map(
        (entry) {
          final signalName = entry.key;
          final spots = entry.value;
          final axisData = _axesData[signalName]!;
          return LineChartBarData(
            barWidth: axisData.showDots ? 0 : axisData.thickness,
            show: axisData.isVisible,
            spots: spots,
            color: axisData.color,
            dotData: FlDotData(
              show: axisData.showDots,
              getDotPainter: (spot, xPercentage, bar, index) {
                  return FlDotCirclePainter(
                  radius: axisData.dotRadius,
                  color: bar.color ?? Colors.green,
                  strokeWidth: 0,
                );
              },
            ),
          );
        },
      ).toList();
  }
  ///
  AxisTitles get _hiddenTitles => AxisTitles(
    sideTitles: SideTitles(
      showTitles: false,
    ),
  );
  ///
  FlTitlesData get _titlesData => FlTitlesData(
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50.0,
        interval: _yInterval,
        getTitlesWidget: (value, meta) {
          return YTitle(
            value: value,
            meta: meta,
          );
        },
      ),
    ),
    topTitles: _hiddenTitles,
    rightTitles: _hiddenTitles,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50.0,
        interval: _xInterval,
        getTitlesWidget: (value, meta) {
          return XTitle(
            date: DateTime.fromMillisecondsSinceEpoch(value.toInt()), 
            meta: meta,
          );
        },
      ),
    ),
  );
}
