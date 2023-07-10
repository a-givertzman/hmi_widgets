import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
  const LiveChartMarkup({this.verticalLines, this.horizontalLines});
}