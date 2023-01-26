import 'dart:math';
import 'package:flutter/material.dart';
import 'swl_data.dart';

class SwlDataConverter {
  final double _xScale;
  final double _yScale;
  final double _height;
  final SwlData _swlData;
  final List<double> _swlLimitSet;
  final List<Color> _swlColorSet;

  SwlDataConverter({
    required SwlData swlData,
    required double rawHeight,
    required double rawWidth,
    required double height,
    required double width,
    required List<double> swlLimitSet,
    required List<Color> swlColorSet,
  }) : _swlData = swlData,
    _height = height,
    _xScale = rawWidth / width,
    _yScale = rawHeight / height,
    _swlColorSet = swlColorSet,
    _swlLimitSet = swlLimitSet;
  
  Future<List<Offset>> get points async {
    final points = await Future.wait([_swlData.x, _swlData.y]);
    return _convertPoints(points[0], points[1]);
  }

  Future<List<List<Color>>> get swlColors async {
    final swlColorValues = await _swlData.swl;
    return _convertSwlColors(swlColorValues);
  }

  List<Offset> _convertPoints(List<double> x, List<double> y) {
    final List<Offset> points = [];
    final count = max(x.length, y.length);
    for (int i = 0; i < count; i++) {
      final dx = x[i] / _xScale;
      final dy = _height - y[i] / _yScale;
      points.add(Offset(dx, dy));
    }
    return points;
  }

  List<List<Color>> _convertSwlColors(List<List<double>> swl) {
    final List<List<Color>> colors = [
      for (final _ in swl)
        []
    ];
    for (int j = 0; j < swl.length; j++) {
      for (int i = 0; i < swl[0].length; i++) {
        colors[j].add(_swlColor(swl[j][i]));
      }
    }
    return colors;
  }

  Color _swlColor(double swl) {
    final colorIndex = _swlLimitSet.lastIndexWhere((swlElement) {
      return swlElement <= swl;
    });
    return _swlColorSet[colorIndex < 0 ? 0 : colorIndex];
  }
}