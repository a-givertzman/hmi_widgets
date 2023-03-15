import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'live_chart.dart';
import 'live_axis.dart';
import 'live_chart_legend.dart';
import 'show_dots_switch.dart';

/// Displays [LiveChart] with [LiveChartLegend] and [ShowDotsSwitch].
class LiveChartWidget extends StatefulWidget {
  final double _legendWidth;
  final double? _minY;
  final double? _maxY;
  final double? _minX;
  final double? _maxX;
  final double? _yInterval;
  final double? _xInterval;
  final List<LiveAxis> _axes;
  final Duration _autoScrollDelay;
  ///
  const LiveChartWidget({
    super.key,
    required List<LiveAxis> axes,
    double? minY,
    double? maxY,
    double? minX,
    double? maxX,
    double? xInterval,
    double? yInterval,
    double legendWidth = 200,
    Duration autoScrollDelay = const Duration(seconds: 0),
  }) : 
    _axes = axes,
    _minY = minY,
    _maxY = maxY,
    _minX = minX,
    _maxX = maxX,
    _xInterval = xInterval,
    _yInterval = yInterval,
    _legendWidth = legendWidth,
    _autoScrollDelay = autoScrollDelay;
  //
  @override
  State<LiveChartWidget> createState() => _LiveChartWidgetState(
    axes: _axes,
    minY: _minY,
    maxY: _maxY,
    minX: _minX,
    maxX: _maxX,
    xInterval: _xInterval,
    yInterval: _yInterval,
    legendWidth: _legendWidth,
    autoScrollDelay: _autoScrollDelay,
  );
}
///
class _LiveChartWidgetState extends State<LiveChartWidget> with SingleTickerProviderStateMixin {
  static final _log = const Log('_LiveChartState')..level = LogLevel.debug;
  final double _legendWidth;
  final double? _minY;
  final double? _maxY;
  double? _minX;
  double? _maxX;
  late final double _startMinX;
  late final double _startMaxX;
  final double? _xInterval;
  final double? _yInterval;
  final Map<String, LiveAxis> _axesData = {};
  final Duration _autoScrollDelay;
  late final Map<String, List<FlSpot>> _points;
  late final StreamSubscription<DsDataPoint<double>> _subscription;
  late final Ticker _ticker;
  bool _isAutoScrollStarted = false;
  ///
  _LiveChartWidgetState({
    required double? minY,
    required double? maxY,
    required double? minX,
    required double? maxX,
    required double? yInterval,
    required double? xInterval,
    required List<LiveAxis> axes,
    required double legendWidth,
    required Duration autoScrollDelay,
  }) : 
    _minY = minY,
    _maxY = maxY,
    _minX = minX,
    _maxX = maxX,
    _xInterval = xInterval,
    _yInterval = yInterval,
    _legendWidth = legendWidth,
    _autoScrollDelay = autoScrollDelay 
  {
    for (final axisData in axes) {
      _axesData[axisData.signalName] = axisData;
    }
  }
  //
  @override
  void initState() {
    _log.debug('[.initState]');
    final now = DateTime.now();
    _minX ??= _getMinX(now);
    _maxX ??= _getMaxX(now);
    _startMinX = _minX!;
    _startMaxX = _maxX!;
    _ticker = createTicker((elapsed) {
      final elapsedX = elapsed.inMilliseconds;
      _maxX = _startMaxX + elapsedX;
      _minX = _startMinX + elapsedX;
      if (mounted) setState(() {return;});
    });
    Future.delayed(_autoScrollDelay, () {
      _isAutoScrollStarted = true;
      _ticker.start();
    });
    _points = _axesData.map((key, _) => MapEntry(key, []));
    _subscription = StreamMerged([
      for (final axisData in _axesData.values)
        axisData.stream,
    ]).stream.listen((event) {
      final eventName = event.name.name;
      final xValue = DateTime.parse(event.timestamp).millisecondsSinceEpoch.toDouble();
      final yValue = event.value;
      _points[eventName]!.add(FlSpot(xValue, yValue));
      if (_points[eventName]!.length > _axesData[eventName]!.bufferLength) {
        _points[eventName]!.removeAt(0);
      }
      if(!_isAutoScrollStarted) setState(() {return;});
    });
    super.initState();
  }
  ///
  double _getMinX(DateTime now) => now.subtract(const Duration(seconds: 25))
    .millisecondsSinceEpoch.toDouble();
  ///
  double _getMaxX(DateTime now) => now.add(const Duration(seconds: 5))
    .millisecondsSinceEpoch.toDouble();
  //
  @override
  void dispose() {
    _subscription.cancel();
    _ticker.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Stack(
      children: [
        LiveChart(
          minX: _minX,
          maxX: _maxX,
          minY: _minY,
          maxY: _maxY,
          yInterval: _yInterval,
          xInterval: _xInterval,
          axesData: _axesData,
          points: _points,
        ),
        Positioned(
          left: padding * 6,
          top: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShowDotsSwitch(
                width: _legendWidth,
                isOn: _axesData.values.every((axisData) => axisData.showDots),
                onChanged: (showDots) {
                  for (final axisData in _axesData.values) {
                    axisData.showDots = showDots;
                  }
                },
              ),
              SizedBox(height: padding / 4),
              LiveChartLegend(
                legendWidth: _legendWidth,
                axes: _axesData.values.toList(),
                onChanged: (signal, isVisible) {
                  _axesData[signal]!.isVisible = isVisible;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}