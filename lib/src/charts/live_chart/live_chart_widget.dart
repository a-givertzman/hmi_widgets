import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/src/charts/live_chart/chart_action_button.dart';
import 'live_chart.dart';
import 'live_axis.dart';
import 'live_chart_legend.dart';
import 'pause_switch.dart';
import 'show_dots_switch.dart';
import 'show_legend_switch.dart';

/// Displays [LiveChart] with [LiveChartLegend] and [ShowDotsSwitch].
class LiveChartWidget extends StatefulWidget {
  final double _legendWidth;
  final double? _minY;
  final double? _maxY;
  final double? _minX;
  final double? _maxX;
  final double? _yInterval;
  final double? _xInterval;
  final LiveChartMarkup? _markup;
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
    LiveChartMarkup? markup,
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
    _markup = markup,
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
    markup: _markup,
    legendWidth: _legendWidth,
    autoScrollDelay: _autoScrollDelay,
  );
}
///
class _LiveChartWidgetState extends State<LiveChartWidget> with SingleTickerProviderStateMixin {
  static final _log = const Log('_LiveChartState')..level = LogLevel.debug;
  static const _scrollSpeed = 22.5;
  static const _minXDelta = 1000.0;
  static const _maxXDelta = 300000.0;
  final double _legendWidth;
  final double? _minY;
  final double? _maxY;
  double? _minX;
  double? _maxX;
  late double _startMinX;
  late double _startMaxX;
  final double? _xInterval;
  final double? _yInterval;
  final LiveChartMarkup? _markup;
  final Map<String, LiveAxis> _axesData = {};
  final Duration _autoScrollDelay;
  late final Map<String, List<FlSpot>> _points;
  late final StreamSubscription<DsDataPoint<double>> _subscription;
  late final Ticker _ticker;
  late final Timer _autoScrollDelayTimer;
  bool _isAutoScrollStarted = false;
  bool _showLegend = true;
  ///
  _LiveChartWidgetState({
    required double? minY,
    required double? maxY,
    required double? minX,
    required double? maxX,
    required double? yInterval,
    required double? xInterval,
    required LiveChartMarkup? markup,
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
    _markup = markup,
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
    _autoScrollDelayTimer = Timer(_autoScrollDelay, () {
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
  //
  @override
  void dispose() {
    _autoScrollDelayTimer.cancel();
    _subscription.cancel();
    _ticker.dispose();
    super.dispose();
  }
  ///
  double _getMinX(DateTime now) => now.subtract(const Duration(seconds: 30))
    .millisecondsSinceEpoch.toDouble();
  ///
  double _getMaxX(DateTime now) => now.add(const Duration(seconds: 0))
    .millisecondsSinceEpoch.toDouble();
    ///
  void _pauseChart() {
    setState(() {
      if (_autoScrollDelayTimer.isActive) {
        _autoScrollDelayTimer.cancel();
      }
      if (_ticker.isActive) {
        _ticker.stop();
      }
      if (!_subscription.isPaused) {
        _subscription.pause();
      }
    });
  }
  ///
  void _playChart() {
    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    final xRange = _maxX! - _minX!;
    setState(() {
      _startMaxX = _maxX = now;
      _startMinX =_minX = now - xRange;
      if (!_ticker.isActive) {
        _ticker.start();
      }
      if (_subscription.isPaused) {
        _subscription.resume();
      }
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (details) {
            _pauseChart();
            final delta = details.primaryDelta ?? 0;
            _log.debug('drag update: $delta');
            final shift = _scrollSpeed * delta;
            setState(() {
              _minX = _minX! - shift;
              _maxX = _maxX! - shift;
            });
          },
          child: AbsorbPointer(
            child: LiveChart(
              minX: _minX,
              maxX: _maxX,
              minY: _minY,
              maxY: _maxY,
              yInterval: _yInterval,
              xInterval: _xInterval ?? (_maxX! - _minX!) / 6.0,
              markup: _markup,
              axesData: _axesData,
              points: _points,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: ShowDotsSwitch(
                      isOn: _axesData.values.every((axisData) => axisData.showDots),
                      onChanged: (showDots) {
                        setState(() {
                          for (final axisData in _axesData.values) {
                            axisData.showDots = showDots;
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: ShowLegendSwitch(
                      isOn: _showLegend, 
                      onChanged: (value) {
                        setState(() {
                          _showLegend = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: ChartActionButton(
                      tooltip: const Localized('Zoom out').v,
                      icon: Icon(Icons.remove),
                      onPressed: _maxX! - _minX! < _maxXDelta 
                        ? () {
                          final isChartWasActive = _ticker.isActive;
                          _pauseChart();
                          setState(() {
                            double newMinX = _minX! - _computeTimeRangeStep(_maxX! - _minX!);
                            final newXDelta = _maxX! - newMinX;
                            newMinX = newXDelta < _maxXDelta ? newMinX : _maxX! - _maxXDelta;
                            _startMinX = newMinX;
                            _minX = newMinX;
                          });
                          if(isChartWasActive) {
                            _playChart();
                          }
                        } 
                        : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: ChartActionButton(
                      tooltip: const Localized('Zoom in').v,
                      icon: Icon(Icons.add),
                      onPressed: _maxX! - _minX! > _minXDelta 
                        ? () {
                          final isChartWasActive = _ticker.isActive;
                          _pauseChart();
                          setState(() {
                            double newMinX = _minX! + _computeTimeRangeStep(_maxX! - _minX!);
                            final newXDelta = _maxX! - newMinX;
                            newMinX = newXDelta > _minXDelta ? newMinX : _maxX! - _minXDelta;
                            _startMinX = newMinX;
                            _minX = newMinX;
                          });
                          if(isChartWasActive) {
                            _playChart();
                          }
                        } 
                        : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: PauseSwitch(
                      isOn: !_ticker.isActive, 
                      onChanged: (isPaused) {
                        if (isPaused) {
                          _pauseChart();
                        } else {
                          _playChart();
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (_showLegend)
                LiveChartLegend(
                  legendWidth: _legendWidth,
                  axes: _axesData.values.toList(),
                  onChanged: (signal, isVisible) {
                    setState(() {
                      _axesData[signal]!.isVisible = isVisible;
                    });
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  double _computeTimeRangeStep(double currentTimeRange) {
    return 0.05 * currentTimeRange + 5000.0;
  }
}
