import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Рисует график по данным и потока
class LiveChartWidget extends StatefulWidget {
  final double _minY;
  final double _maxY;
  final Stream<DsDataPoint<double>>? _stream;
  final Color? _axisColor;
  final double? _yInterval;
  final double? _xInterval;
  final String? _caption;
  ///
  const LiveChartWidget({
    Key? key,
    required double minY,
    required double maxY,
    Stream<DsDataPoint<double>>? stream,
    Color? axisColor,
    double? yInterval,
    double? xInterval,
    String? caption,
  }) : 
    _minY = minY,
    _maxY = maxY,
    _stream = stream,
    _axisColor = axisColor,
    _yInterval = yInterval,
    _xInterval = xInterval,
    _caption = caption,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<LiveChartWidget> createState() => _LiveChartWidgetState(
    minY: _minY,
    maxY: _maxY,
    stream: _stream,
    axisColor: _axisColor,
    yInterval: _yInterval,
    xInterval: _xInterval,
    caption: _caption,
  );
}

///
class _LiveChartWidgetState extends State<LiveChartWidget> {
  final double _minY;
  final double _maxY;
  final Stream<DsDataPoint<double>>? _stream;
  final _points = <FlSpot>[];
  final Color? _axisColor;
  final double? _yInterval;
  final double? _xInterval;
  final String? _caption;
  late Color _chartLineColor;// = Colors.greenAccent[300]!;
  late Timer _timer;
  ///
  _LiveChartWidgetState({
    required double minY,
    required double maxY,
    required Stream<DsDataPoint<double>>? stream,
    required Color? axisColor,
    required double? yInterval,
    required double? xInterval,
    required String? caption,
  }) :
    _minY = minY,
    _maxY = maxY,
    _stream = stream,
    _axisColor = axisColor,
    _yInterval = yInterval,
    _xInterval = xInterval,
    _caption = caption,
    super();
  //
  @override
  void initState() {
    _chartLineColor = Colors.greenAccent;
    const limitCount = 2000;
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
    final stream = _stream;
    if (stream != null) {
      stream.listen((event) {
        final xValue = DateTime.parse(event.timestamp).millisecondsSinceEpoch.toDouble();
        final yValue = event.value;
        _points.add(FlSpot(xValue, yValue));
        if (_points.length > limitCount) {
          _points.removeAt(0);
        }
      });
    }
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final minX = now.subtract(const Duration(seconds: 25)).millisecondsSinceEpoch.toDouble();
    final maxX = now.add(const Duration(seconds: 5)).millisecondsSinceEpoch.toDouble();
    final xInterval = _xInterval ?? _xInterval! * 2;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 10.0,
            child: Text(_caption ?? ''),
          ),
          LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: _minY,
              maxY: _maxY,
              clipData: FlClipData(
                top: true,
                bottom: true,
                left: true,
                right: true,
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                horizontalInterval: _yInterval,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: _axisColor,
                    strokeWidth: 0.5,
                  );
                },
                verticalInterval: _xInterval,
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: _axisColor,
                    strokeWidth: 0.5,
                  );
                },
              ),
              lineBarsData: [
                _chartLine(_points),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50.0,
                    interval: _yInterval,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toStringAsFixed(1));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  drawBehindEverything: false,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: xInterval,
                    getTitlesWidget: (value, meta) {
                      if (value > meta.min && value < meta.max - xInterval * 0.2) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text('${date.hour}:${date.minute}:${date.second}');
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
            ),
            swapAnimationDuration: Duration.zero,
          ),
        ],
      ),
    );
  }
  //
  LineChartBarData _chartLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      color: _chartLineColor,
      // gradient: LinearGradient(
      //   colors: [_chartLineColor.withOpacity(0), _chartLineColor],
      //   // begin: Alignment.centerLeft,
      //   // end: Alignment.centerRight,
      //   stops: const [0.1, 1.0],
      // ),
      // barWidth: 1,
      // isCurved: false,
      // isStepLineChart: true,
    );
  }
  //
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
