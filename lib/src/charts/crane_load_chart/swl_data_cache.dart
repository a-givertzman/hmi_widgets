import 'dart:math';
import 'dart:ui';

import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data.dart';

class SwlDataCache {
  final double _xScale;
  final double _yScale;
  final double _height;
  final List<double> _swlLimitSet;
  final List<Color> _swlColorSet;
  final SwlData _swlData;

  final List<Offset> _points = [];
  final List<List<Color>> _swlColors = [];

  SwlDataCache({
    required SwlData swlData,
    required double rawWidth,
    required double rawHeight,
    required double width,
    required double height,
    required List<double> swlLimitSet,
    required List<Color> swlColorSet,
  }) : _swlData = swlData,
  _xScale = rawWidth / width,
  _yScale = rawHeight / height,
  _height = height,
  _swlLimitSet = swlLimitSet,
  _swlColorSet = swlColorSet;

  Future<List<Offset>> get points async { 
    if (_points.isNotEmpty) { 
      return Future.value(_points);
    } 
    final points = await Future.wait([_swlData.x, _swlData.y]);
    _points.addAll(_convertPoints(points[0], points[1]));
    return _points;
  }

  Future<List<List<Color>>> get swlColors async {
    if (_swlColors.isNotEmpty) {
      return Future.value(_swlColors);
    }
    final swlColorValues = await _swlData.swl;
    _swlColors.addAll(_convertSwlColors(swlColorValues));
    return _swlColors;
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