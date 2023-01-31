import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_data.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';
import 'swl_data.dart';

///
/// common comment to the class purpose
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
  /// comment to the all input parameters
  /// 
  SwlDataConverter({
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
  List<List<Color>> _convertSwlColors(List<List<double>> swl) {
    return swl.map((swlLayer) {
      return swlLayer.map((swlLayerValue) {
        return _swlColor(swlLayerValue);
      }).toList();
    }).toList();
  }  
  ///
  Color _swlColor(double swl) {
    double minLimit = 0.0;
    for(int i = 0; i < _legendData.limits.length; i++) {
      if(swl <= minLimit) {
        return _legendData.colors.elementAt(i);
      }
      minLimit = _legendData.limits.elementAt(i);
    }
    return _legendData.colors.last;
  }
  
  @override
  double get height => _height;
  
  @override
  double get width => _width;
  
  @override
  double get rawHeight => _rawHeight;
  
  @override
  double get rawWidth => _rawWidth;
  
  @override
  CraneLoadChartLegendData get legendData => _legendData;
}