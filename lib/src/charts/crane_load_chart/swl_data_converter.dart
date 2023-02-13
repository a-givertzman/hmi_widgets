import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_data.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';
import 'swl_data.dart';

///
/// Converts swl data from three separated arrays
class SwlDataConverter implements CraneLoadChartData {
  final double _xScale;
  final double _yScale;
  final double _height;
  final double _width;
  final double _rawHeight;
  final double _rawWidth;
  final SwlData _swlData;
  final CraneLoadChartLegendData _legendData;
  ///
  /// - swlData - separated arrays coming from csv files
  /// - rawHeight - real height of the Crane load area, m
  /// - rawWidth - real width of the Crane load area, m
  /// - height - height of the CraneLoadChart widget canvas, px
  /// - width - width of the CraneLoadChart widget canvas, px
  /// - legendData - data (limits, colors, names) for CraneLoadChart legend
  const SwlDataConverter({
    required SwlData swlData,
    required double rawHeight,
    required double rawWidth,
    required double height,
    required double width,
    required CraneLoadChartLegendData legendData,
  }) : 
    _swlData = swlData,
    _height = height,
    _width = width,
    _rawHeight = rawHeight,
    _rawWidth = rawWidth,
    _xScale = rawWidth / width,
    _yScale = rawHeight / height,
    _legendData = legendData;
  ///
  Future<List<Offset>> get points async {
    final points = await Future.wait([_swlData.x, _swlData.y]);
    return _convertPoints(points[0], points[1]);
  }
  ///
  Future<List<List<Color>>> get swlColors async {
    final swlColorValues = await _swlData.swl;
    return _convertSwlColors(swlColorValues);
  }
  ///
  List<Offset> _convertPoints(List<double> x, List<double> y) {
    final List<Offset> points = [];
    // TODO remove max after dimensions checked in the SwlData
    final count = max(x.length, y.length);
    for (int i = 0; i < count; i++) {
      final dx = x[i] / _xScale;
      final dy = _height - y[i] / _yScale;
      points.add(Offset(dx, dy));
    }
    return points;
  }
  ///
  Future<List<List<Color>>> _convertSwlColors(List<List<double>> swl) async {
    final limits = await _legendData.limits;
    final segments = limits.map((e) => _getSegments(e)).toList();
    return [
      for (int layerIndex = 0; layerIndex < swl.length; layerIndex++) [
        for (final swlValue in swl[layerIndex])
          await _pickSwlColor(
            layerIndex, 
            swlValue, 
            segments[layerIndex],
          )
      ]
    ];
  }  
  ///
  Future<Color> _pickSwlColor(int layerIndex, double swl, List<_Gap> segments) async {
    final colorIndex = segments.indexWhere(
      (segment) => segment.contains(swl),
    );
    final colors = await _legendData.colors;
    return colors.elementAt(layerIndex).elementAt(colorIndex);
  }
  ///
  List<_Gap> _getSegments(Iterable<double> limits) {
    final segments = <_Gap>[
      _Gap(0.0, limits.first),
    ];
    for(int i = 0; i < limits.length-1; i++) {
      segments.add(_Gap(limits.elementAt(i), limits.elementAt(i+1)));
    }
    return segments;
  }
  //
  @override
  double get height => _height;
  //
  @override
  double get width => _width;
  //
  @override
  double get rawHeight => _rawHeight;
  //
  @override
  double get rawWidth => _rawWidth;
  //
  @override
  CraneLoadChartLegendData get legendData => _legendData;
}
///
class _Gap {
  final double leftBorder;
  final double rightBorder;
  ///
  const _Gap(this.leftBorder, this.rightBorder);
  ///
  bool contains(double value) => value >= leftBorder && value < rightBorder;
}