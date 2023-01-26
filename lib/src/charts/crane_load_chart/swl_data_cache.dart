import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_converter.dart';

class SwlDataCache {
  final SwlDataConverter _swlDataConverter;

  final List<Offset> _points = [];
  final List<List<Color>> _swlColors = [];

  SwlDataCache({
    required SwlDataConverter swlDataConverter,
  }) : _swlDataConverter = swlDataConverter;

  Future<List<Offset>> get points async { 
    if (_points.isNotEmpty) { 
      return Future.value(_points);
    }
    _points.addAll(await _swlDataConverter.points);
    return _points;
  }

  Future<List<List<Color>>> get swlColors async {
    if (_swlColors.isNotEmpty) {
      return Future.value(_swlColors);
    }
    _swlColors.addAll(await _swlDataConverter.swlColors);
    return _swlColors;
  }
}